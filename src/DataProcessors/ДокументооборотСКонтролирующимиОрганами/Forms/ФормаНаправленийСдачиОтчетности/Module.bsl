&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ДанныеЗаполнения;

&НаКлиенте
Перем ДанныеОрганизации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокЗначенийПолучатели 	= Параметры.Получатели;
	ТипПолучателя 				= Параметры.ТипПолучателя;
	Спецоператор 				= Параметры.Спецоператор;
	Организация 				= Параметры.Организация;
	
	ФНС 	= Перечисления.ТипыКонтролирующихОрганов.ФНС;
	ФСГС 	= Перечисления.ТипыКонтролирующихОрганов.ФСГС;

	Для каждого СтрокаСпискаПолучателей Из СписокЗначенийПолучатели Цикл
		
		Если ТипПолучателя = ФНС Тогда
			НоваяСтрока = ПолучателиФНС.Добавить();
		Иначе
			НоваяСтрока = ПолучателиФСГС.Добавить();
		КонецЕсли;
			
		НоваяСтрока.ТипПолучателя 	= ТипПолучателя;
		НоваяСтрока.КодПолучателя 	= СтрокаСпискаПолучателей.Значение;
		НоваяСтрока.КПП 			= СтрокаСпискаПолучателей.Представление;
	КонецЦикла;
	
	Если ТипПолучателя = ФНС Тогда
		Заголовок = НСтр("ru = 'Изменение кодов ФНС';
						|en = 'Изменение кодов ФНС'");
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.ГруппаФНС;
	Иначе
		Заголовок = НСтр("ru = 'Изменение кодов Росстата';
						|en = 'Изменение кодов Росстата'");
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.ГруппаФСГС;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПолучателиФНСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактироватьВыбранноеНаправлениеФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФСГСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактироватьВыбранноеНаправлениеФСГС();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОК(Команда)
	
	СписокЗначенийПолучатели = Новый СписокЗначений;
	
	Если ТипПолучателя = ФНС Тогда
		Получатели = ПолучателиФНС;
	Иначе
		Получатели = ПолучателиФСГС;
	КонецЕсли;
	
	Для каждого СтрокаСпискаПолучателей Из Получатели Цикл
		СписокЗначенийПолучатели.Добавить(СтрокаСпискаПолучателей.КодПолучателя, СтрокаСпискаПолучателей.КПП);
	КонецЦикла;
	
	Закрыть(СписокЗначенийПолучатели);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНаправлениеФНС(Команда)
	
	ВосстановитьНаправления(ФНС);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНаправлениеФНС(Команда)
	
	ОткрытьФормуНаправления("Добавить");

КонецПроцедуры

&НаКлиенте
Процедура УдалитьНаправлениеФНС(Команда)
	
	КонтекстЭДОКлиент.УдалитьНаправление(
		ЭтотОбъект, 
		ПолучателиФНС, 
		"ПолучателиФНС", 
		"УдалитьНаправлениеФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНаправлениеФНС(Команда)
	
	РедактироватьВыбранноеНаправлениеФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНаправлениеФСГС(Команда)
	
	ДобавитьНовоеНаправлениеФСГС();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНаправлениеФСГС(Команда)
	
	РедактироватьВыбранноеНаправлениеФСГС();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНаправлениеФСГС(Команда)
	
	КонтекстЭДОКлиент.УдалитьНаправление(
		ЭтотОбъект, 
		ПолучателиФСГС, 
		"ПолучателиФСГС", 
		"УдалитьНаправлениеФСГС");
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВосстановитьНаправленияФСГС(Команда)
	
	ВосстановитьНаправления(ФСГС);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДобавлениеУдалениеРедактированиеКодовОрганов

#Область ДобавлениеИРедактированиеФНС

&НаКлиенте
Процедура РедактироватьВыбранноеНаправлениеФНС()
	
	ТекущаяСтрока = Элементы.ПолучателиФНС.ТекущаяСтрока;
	
	Если КонтекстЭДОКлиент.ТекущаяСтрокаВыбрана(ПолучателиФНС,ТекущаяСтрока,"редактирования") Тогда

		ОткрытьФормуНаправления("Редактировать");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНаправления(Действие)
	
	АдресПолучателей = АдресПолучателей("ПолучателиФНС");
	
	КонтекстЭДОКлиент.ОткрытьФормуНаправления(
		ЭтотОбъект, 
		Действие, 
		"ПолучателиФНС", 
		ДанныеОрганизации, 
		Истина,
		АдресПолучателей);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьФормуНаправленияЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент.ОткрытьФормуНаправленияЗавершение(
		ЭтотОбъект,
		ПолучателиФНС,
		Результат,
		ВходящийКонтекст);
		
	СкрытьКнопкуУдаленияНаправления(ФНС);
		
КонецПроцедуры

&НаСервере
Функция АдресПолучателей(ИмяТаблицыФормы) Экспорт

	ТаблицаПолучателей = ЭтотОбъект[ИмяТаблицыФормы].Выгрузить();
	Возврат ПоместитьВоВременноеХранилище(ТаблицаПолучателей, Новый УникальныйИдентификатор);

КонецФункции

#КонецОбласти

#Область ВосстановлениеФНСиФСГС

&НаКлиенте
Процедура ВосстановитьНаправления(КонтролирующийОрган)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить(
		"КонтролирующийОрган", 
		КонтролирующийОрган);
	 
	ПодтвердитьВосстановлениеНаправления(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьВосстановлениеНаправления(ДополнительныеПараметры)
	
	ОписаниеОповещения 	= Новый ОписаниеОповещения(
		"ВосстановитьНаправленияЗавершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	ТекстВопроса = НСтр("ru = 'Восстановить значения кодов по умолчанию?';
						|en = 'Восстановить значения кодов по умолчанию?'");
	
	ПоказатьВопрос(
		ОписаниеОповещения, 
		ТекстВопроса, 
		РежимДиалогаВопрос.ДаНет
		,
		,
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНаправленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		КонтролирующийОрган = ДополнительныеПараметры.КонтролирующийОрган;
		
		Если КонтролирующийОрган = ФНС Тогда
		
			ПолучателиФНС.Очистить();
			ВосстановитьНаправленияПоУмолчанию(ФНС);
			
		ИначеЕсли КонтролирующийОрган = ФСГС Тогда
			
			ПолучателиФСГС.Очистить();
			ВосстановитьНаправленияПоУмолчанию(ФСГС);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНаправленияПоУмолчанию(КонтролирующийОрган = Неопределено)
	
	Если КонтролирующийОрган = ФНС ИЛИ КонтролирующийОрган = Неопределено Тогда
	
		КонтекстЭДОКлиент.ВосстановитьНаправленияПоУмолчаниюФНС(
			ПолучателиФНС, 
			ДанныеОрганизации);
			
		СкрытьКнопкуУдаленияНаправления(ФНС);
		
	КонецЕсли;
	
	Если КонтролирующийОрган = ФСГС ИЛИ КонтролирующийОрган = Неопределено Тогда
		
		КонтекстЭДОКлиент.ВосстановитьНаправленияПоУмолчаниюФСГС(
			ПолучателиФСГС, 
			ДанныеОрганизации);
			
		СкрытьКнопкуУдаленияНаправления(ФСГС);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РедактированиеФСГС

&НаКлиенте
Процедура РедактироватьВыбранноеНаправлениеФСГС()

	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.ПолучателиФСГС.ТекущаяСтрока;
	Если КонтекстЭДОКлиент.ТекущаяСтрокаВыбрана(ПолучателиФСГС, ТекущаяСтрока,"редактирования") Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеКодРосстатаЗавершение", ЭтотОбъект);
	
		КонтекстЭДОКлиент.КодРосстата(
			Элементы.ПолучателиФСГС.ТекущиеДанные.КодПолучателя, 
			Спецоператор, 
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура РедактированиеКодРосстатаЗавершение(ВыбранныйОрганТОГС, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйОрганТОГС <> Неопределено Тогда
		
		НовыеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		НовыеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		НовыеЗначенияПолучателя.Вставить("КодПолучателя", 	ВыбранныйОрганТОГС.КодТОГС);
		
		ПредыдущиеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		ПредыдущиеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		ПредыдущиеЗначенияПолучателя.Вставить("КодПолучателя", 	Элементы.ПолучателиФСГС.ТекущиеДанные.КодПолучателя);
		
		Если КонтекстЭДОКлиент.НаправлениеУникально(ПолучателиФСГС, "Редактировать", НовыеЗначенияПолучателя, ПредыдущиеЗначенияПолучателя) Тогда
			
			ИдентификаторСтроки 		= Элементы.ПолучателиФСГС.ТекущаяСтрока;
			ТекущаяСтрока 				= ПолучателиФСГС.НайтиПоИдентификатору(ИдентификаторСтроки);
			ТекущаяСтрока.КодПолучателя = ВыбранныйОрганТОГС.КодТОГС;
			
			Элементы.ПолучателиФСГС.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДобавлениеФСГС

&НаКлиенте
Процедура ДобавитьНовоеНаправлениеФСГС()

	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеКодРосстатаЗавершение", ЭтотОбъект);
	
	КонтекстЭДОКлиент.КодРосстата(
		Неопределено, 
		Спецоператор, 
		ОписаниеОповещения);

КонецПроцедуры 

&НаКлиенте
Процедура ДобавлениеКодРосстатаЗавершение(ВыбранныйОрганТОГС, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйОрганТОГС <> Неопределено Тогда
		
		НовыеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		НовыеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		НовыеЗначенияПолучателя.Вставить("КодПолучателя", 	ВыбранныйОрганТОГС.КодТОГС);
		
		Если КонтекстЭДОКлиент.НаправлениеУникально(ПолучателиФСГС, "Добавить", НовыеЗначенияПолучателя) Тогда
		
			НоваяСтрока = ПолучателиФСГС.Добавить();
			НоваяСтрока.ТипПолучателя = ФСГС;
			НоваяСтрока.КодПолучателя = ВыбранныйОрганТОГС.КодТОГС;
			
			Элементы.ПолучателиФСГС.Обновить();
			
			СкрытьКнопкуУдаленияНаправления(ФСГС);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УдалениеФНСиФСГС

&НаКлиенте
Процедура УдалитьНаправлениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ИмяТаблицыФормы = ДополнительныеПараметры.ИмяТаблицыФормы;
	
	КонтекстЭДОКлиент.УдалитьНаправлениеЗавершение(
		ЭтотОбъект, 
		ЭтотОбъект[ИмяТаблицыФормы],
		РезультатВопроса, 
		ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СкрытьКнопкуУдаленияНаправления(КонтролирующийОрган)
	
	Если КонтролирующийОрган = ФНС Тогда 
		Элементы.УдалитьНаправлениеФНС.Доступность 	= ПолучателиФНС.Количество() <> 0;
	ИначеЕсли КонтролирующийОрган = ФСГС Тогда
		Элементы.УдалитьНаправлениеФСГС.Доступность = ПолучателиФСГС.Количество() <> 0;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	// Заполняем текущие реквизиты организации 
	СтруктураРеквизитов = Новый Структура("Организация, ПриОткрытии", Организация, НЕ ДанныеЗаполнения = Неопределено);
	Если ДанныеЗаполнения <> Неопределено Тогда
		СтруктураРеквизитов.Вставить("АдресЮридический",);
		СтруктураРеквизитов.Вставить("АдресФактический",);
	КонецЕсли;
	КонтекстЭДОКлиент.ЗаполнитьДанныеОрганизации(СтруктураРеквизитов);
	ДанныеЗаполнения = КонтекстЭДОКлиент.ДополнитьДанныеОрганизацииДаннымиПоОтветственнымЛицам(СтруктураРеквизитов);
	ДанныеОрганизации = ДанныеЗаполнения.СтруктураДанныхОрганизации;
	
КонецПроцедуры

#КонецОбласти

