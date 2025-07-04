#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоПодразделений(Дерево.ПолучитьЭлементы(), "DMSubdivision", "");
	ЭлементВсеПользователи = Дерево.ПолучитьЭлементы().Вставить(0);
	ЭлементВсеПользователи.Наименование = НСтр("ru = 'Все пользователи';
												|en = 'All users'");
	ЭлементВсеПользователи.ID = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Лист.ID) И Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПользователей

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПодразделений(ВеткаДерева, ТипОбъектаВыбора, ИдентификаторПапки = Неопределено, СтрокаПоиска = Неопределено)
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Если ИдентификаторПапки <> Неопределено Тогда
		РодительИд = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ИдентификаторПапки,
			ТипОбъектаВыбора);
		
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "parent";
		Условие.value = РодительИд;
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "name";
		Условие.value = СтрокаПоиска;
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		Для Каждого СтрокаОтбора Из Отбор Цикл
			Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
			Условие.property = СтрокаОтбора.Ключ;
			
			Если ТипЗнч(СтрокаОтбора.Значение) = Тип("Структура") Тогда
				Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
					Прокси,
					СтрокаОтбора.Значение.ID,
					СтрокаОтбора.Значение.type);
			Иначе
				Условие.value = СтрокаОтбора.Значение;
			КонецЕсли;
		
			СписокУсловийОтбора.Добавить(Условие);
		КонецЦикла;
	КонецЕсли;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		ТипОбъектаВыбора,
		Условия);
	
	Для Каждого Элемент Из Результат.items Цикл
		
		НоваяСтрока = ВеткаДерева.Добавить();
		НоваяСтрока.Наименование = Элемент.object.name;
		НоваяСтрока.ID = Элемент.object.objectID.ID;
		НоваяСтрока.Тип = Элемент.object.objectID.type;
		
		Если ТипОбъектаВыбора = "DMFileFolder" Тогда
			НоваяСтрока.Картинка = 0;
		Иначе
			Если Элемент.isFolder Тогда
				НоваяСтрока.Картинка = 0;
			Иначе
				НоваяСтрока.Картинка = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Элемент.CanHaveChildren И (СтрокаПоиска = Неопределено) Тогда
			НоваяСтрока.ПодпапкиСчитаны = Ложь;
			НоваяСтрока.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
		Иначе
			НоваяСтрока.ПодпапкиСчитаны = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей(ПодразделениеИД)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	// Получение руководителя текущего подразделения
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Подразделение = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
			Прокси,
			"DMSubdivision",
			ПодразделениеИД);
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(Подразделение, "head") Тогда
			IDРуководителя = Подразделение.head.objectID.ID;
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение списка пользователей
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Subdivision";
		Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ПодразделениеИД,
			"DMSubdivision");
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMUser",
		Условия);
	
	СписокПользователей.Очистить();
	Для Каждого ПользовательВСписке Из Результат.Items Цикл
		НоваяСтрока = СписокПользователей.Добавить();
		НоваяСтрока.Наименование = ПользовательВСписке.object.name;
		НоваяСтрока.ID = ПользовательВСписке.object.objectID.ID;
		НоваяСтрока.Тип = ПользовательВСписке.object.objectID.type;
		НоваяСтрока.Руководитель = (IDРуководителя = ПользовательВСписке.object.objectID.ID);
	КонецЦикла;
	
	СписокПользователей.Сортировать("Наименование Возр");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = Дерево.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Лист.ПолучитьЭлементы(), "DMSubdivision", Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ЗаполнитьСписокПользователей(Элементы.Дерево.ТекущиеДанные.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("РеквизитID",  ТекущиеДанные.ID);
	Результат.Вставить("РеквизитТип", ТекущиеДанные.Тип);
	Результат.Вставить("РеквизитПредставление", ТекущиеДанные.Наименование);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти