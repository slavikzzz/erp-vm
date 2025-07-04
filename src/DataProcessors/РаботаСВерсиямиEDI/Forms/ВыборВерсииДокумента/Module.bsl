
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьПараметрыОткрытияФормы();
	УстановитьУсловноеОформлениеФормы();
	
	ДлительнаяОперацияПолучениеВерсий = ЗапуститьПолучениеВерсийДокумента(Организация, ТипДокумента, Документ, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОжидатьПолучениеВерсий();
	ОбновитьОтображениеФормы()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаВерсийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПриВыбореВерсии();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ПриВыбореВерсии();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормой

&НаСервере
Процедура ПрочитатьПараметрыОткрытияФормы()
	
	Параметры.Свойство("Заголовок"         ,               Заголовок);
	Параметры.Свойство("ТипДокумента"      ,               ТипДокумента);
	Параметры.Свойство("Документ"          ,               Документ);
	Параметры.Свойство("Версия"            ,               Версия);
	Параметры.Свойство("ВерсияДляСравнения",               ВерсияДляСравнения);
	Параметры.Свойство("АктуальнаяВерсия",                 АктуальнаяВерсия);
	Параметры.Свойство("ПрисланнаяНаСогласованиеВерсия",   ПрисланнаяНаСогласованиеВерсия);
	Параметры.Свойство("СостояниеРедактированияДокумента", СостояниеРедактированияДокумента);
	Параметры.Свойство("Организация",                      Организация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	// Жирным шрифтом выделяем версию, которая была выбрана ранее
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = НСтр("ru = 'Выделение шрифта начальной версии выбора';
													|en = 'Highlighting the selection initial version font'");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаВерсий.ИдентификаторВерсии");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Версия");
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаВерсий");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифтEDI);
	
	// Серым цветом выделяем версию, которая была выбрана для сравнения
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = НСтр("ru = 'Выделение цвета версии для сравнения';
													|en = 'Highlighting comparison version color'");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаВерсий.ИдентификаторВерсии");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ВерсияДляСравнения");
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаВерсий");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныйДляВыбораЭлементEDI);
	
	// Время текущей ревизии устанавливает как "сейчас"
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = НСтр("ru = 'Отображение даты текущей ревизии документа';
													|en = 'Current document version date display'");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаВерсий.ИдентификаторВерсии");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = РаботаСВерсиямиEDIСервер.ИдентификаторТекущейРевизииСервиса();
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаВерсийДата");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сейчас';
																					|en = 'Now'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеФормы()
	
	Если ДлительнаяОперацияПолучениеВерсий = Неопределено Тогда
		ТекущаяСтраница = Элементы.ГруппаВерсииДокумента;
	Иначе
		ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницы", "ТекущаяСтраница", 
		ТекущаяСтраница);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеВерсийДокумента

&НаСервереБезКонтекста
Функция ЗапуститьПолучениеВерсийДокумента(Организация, ТипДокумента, Документ, УникальныйИдентификаторФормы)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ТипДокумента" , ТипДокумента);
	ПараметрыПроцедуры.Вставить("Документ"     , Документ);
	ПараметрыПроцедуры.Вставить("Организация"  , Организация);
	
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение версий документа';
															|en = 'Getting document versions'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.РаботаСВерсиямиEDI.ПолучитьВерсииДокумента", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОжидатьПолучениеВерсий()
	
	Если ДлительнаяОперацияПолучениеВерсий = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВерсий.Очистить();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияВерсийДокумента", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ПолучатьРезультат    = Истина;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперацияПолучениеВерсий, ОписаниеОповещения, ПараметрыОжидания);
	
	ОбновитьОтображениеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПослеПолученияВерсийДокументаНаСервере(АдресРезультата)
	
	ТаблицаВерсийДокумента = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Для каждого Строка Из ТаблицаВерсийДокумента Цикл
		
		НоваяСтрока = ТаблицаВерсий.Добавить();
		НоваяСтрока.ИдентификаторВерсии = Строка.ИдентификаторВерсии;
		НоваяСтрока.Дата                = Строка.Дата;
		НоваяСтрока.ПредставлениеАвтора = Строка.ПредставлениеАвтора;
		НоваяСтрока.Состояние           = Строка.Состояние;
		
		Если СостояниеРедактированияДокумента = РаботаСВерсиямиEDIКлиентСервер.СостояниеДокументаРассмотрениеПрисланнойВерсии() Тогда
			
			Если НоваяСтрока.ИдентификаторВерсии = ПрисланнаяНаСогласованиеВерсия Тогда
				 НоваяСтрока.Состояние           = НСтр("ru = 'Присланная на согласование';
														|en = 'Received for approval'");
			ИначеЕсли НоваяСтрока.ИдентификаторВерсии = АктуальнаяВерсия Тогда
				 НоваяСтрока.Состояние           = НСтр("ru = 'Текущая';
														|en = 'Current'");
			КонецЕсли;
			
		КонецЕсли;
		
		Если НоваяСтрока.ИдентификаторВерсии = Версия Тогда
			Элементы.ТаблицаВерсий.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияВерсийДокумента(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперацияПолучениеВерсий = Неопределено;
	
	Если РезультатВыполнения = Неопределено  Или Не РезультатВыполнения.Статус = "Выполнено" Тогда
		ОбновитьОтображениеФормы();
		Возврат;
	КонецЕсли;
	
	ПослеПолученияВерсийДокументаНаСервере(РезультатВыполнения.АдресРезультата);
	ОбновитьОтображениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ВыборВерсии

&НаКлиенте
Процедура ПриВыбореВерсии()
	
	Если Элементы.ТаблицаВерсий.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элементы.ТаблицаВерсий.ТекущиеДанные.ИдентификаторВерсии = ВерсияДляСравнения Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Данная версия выбрана как версия для сравнения. Для продолжения выберите версию отличную от сравниваемой.';
										|en = 'This version is selected as the version for comparison. Select a version other than the compared one to continue.'"));
		Возврат;
	КонецЕсли;
	
	Закрыть(Элементы.ТаблицаВерсий.ТекущиеДанные.ИдентификаторВерсии);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти