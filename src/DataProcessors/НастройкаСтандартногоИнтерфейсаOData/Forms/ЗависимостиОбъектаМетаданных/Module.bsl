///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(Параметры.ПолноеИмяОбъекта);
	
	Если ОбщегоНазначения.ЭтоКонстанта(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'константе';
										|en = 'constant'");
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'справочнику';
										|en = 'catalog'");
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'документу';
										|en = 'document'");
	ИначеЕсли ИнтерфейсODataСлужебный.ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'последовательности';
										|en = 'sequence'");
	ИначеЕсли ОбщегоНазначения.ЭтоЖурналДокументов(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'журналу документов';
										|en = 'document journal'");
	ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'перечислению';
										|en = 'enumeration'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовХарактеристик(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану видов характеристик';
										|en = 'chart of characteristic types'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану счетов';
										|en = 'chart of accounts'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану видов расчета';
										|en = 'chart of calculation types'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрСведений(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру сведений';
										|en = 'information register'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрНакопления(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру накопления';
										|en = 'accumulation register'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру бухгалтерии';
										|en = 'accounting register'");
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрРасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'регистру расчета';
										|en = 'calculation register'");
	ИначеЕсли ИнтерфейсODataСлужебный.ЭтоНаборЗаписейПерерасчета(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'перерасчету';
										|en = 'recalculation'");
	ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'бизнес-процессу';
										|en = 'business process'");
	ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'задаче';
										|en = 'task'");
	ИначеЕсли ОбщегоНазначения.ЭтоПланОбмена(ОбъектМетаданных) Тогда
		ПредставлениеТипаОбъекта = НСтр("ru = 'плану обмена';
										|en = 'exchange plan'");
	КонецЕсли;
	
	Если Параметры.Добавление Тогда
		
		Элементы.ГруппаСтраницыШапка.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаДобавление;
		Элементы.ГруппаСтраницыПодвал.ТекущаяСтраница = Элементы.ГруппаСтраницаПодвалДобавление;
		Элементы.ДекорацияЗаголовокШапкаДобавление.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияЗаголовокШапкаДобавление.Заголовок,
			ПредставлениеТипаОбъекта,
			ОбъектМетаданных.Представление());
		
	Иначе
		
		Элементы.ГруппаСтраницыШапка.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаУдаление;
		Элементы.ГруппаСтраницыПодвал.ТекущаяСтраница = Элементы.ГруппаСтраницаПодвалУдаление;
		Элементы.ДекорацияЗаголовокШапкаУдаление.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ДекорацияЗаголовокШапкаУдаление.Заголовок,
			ПредставлениеТипаОбъекта,
			ОбъектМетаданных.Представление());
		
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Заголовок, ОбъектМетаданных.Представление());
	
	// Заполнение дерева
	
	Дерево = Новый ДеревоЗначений();
	
	Дерево.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Класс", Новый ОписаниеТипов("Число", , Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
	Дерево.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	
	ДобавитьКорневуюСтрокуДерева(Дерево, "Константа", НСтр("ru = 'Константы';
															|en = 'Constants'"), 1, БиблиотекаКартинок.Константа);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Справочник", НСтр("ru = 'Справочники';
															|en = 'Catalogs'"), 2, БиблиотекаКартинок.Справочник);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Документ", НСтр("ru = 'Документы';
															|en = 'Documents'"), 3, БиблиотекаКартинок.Документ);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ЖурналДокументов", НСтр("ru = 'Журналы документов';
																	|en = 'Document journals'"), 4, БиблиотекаКартинок.ЖурналДокументов);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Перечисление", НСтр("ru = 'Перечисление';
																|en = 'Enumeration'"), 5, БиблиотекаКартинок.Перечисление);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланВидовХарактеристик", НСтр("ru = 'Планы видов характеристик';
																		|en = 'Charts of characteristic types'"), 6, БиблиотекаКартинок.ПланВидовХарактеристик);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланСчетов", НСтр("ru = 'Планы счетов';
															|en = 'Charts of accounts'"), 7, БиблиотекаКартинок.ПланСчетов);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланВидовРасчета", НСтр("ru = 'Планы видов расчета';
																	|en = 'Charts of calculation types'"), 8, БиблиотекаКартинок.ПланВидовРасчета);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрСведений", НСтр("ru = 'Регистры сведений';
																|en = 'Information registers'"), 9, БиблиотекаКартинок.РегистрСведений);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрНакопления", НСтр("ru = 'Регистры накопления';
																	|en = 'Accumulation registers'"), 10, БиблиотекаКартинок.РегистрНакопления);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрБухгалтерии", НСтр("ru = 'Регистры бухгалтерии';
																	|en = 'Accounting registers'"), 11, БиблиотекаКартинок.РегистрБухгалтерии);
	ДобавитьКорневуюСтрокуДерева(Дерево, "РегистрРасчета", НСтр("ru = 'Регистры расчета';
																|en = 'Calculation registers'"), 12, БиблиотекаКартинок.РегистрРасчета);
	ДобавитьКорневуюСтрокуДерева(Дерево, "БизнесПроцесс", НСтр("ru = 'Бизнес-процессы';
																|en = 'Business processes'"), 13, БиблиотекаКартинок.БизнесПроцесс);
	ДобавитьКорневуюСтрокуДерева(Дерево, "Задача", НСтр("ru = 'Задачи';
														|en = 'Tasks'"), 14, БиблиотекаКартинок.Задача);
	ДобавитьКорневуюСтрокуДерева(Дерево, "ПланОбмена", НСтр("ru = 'Планы обмена';
															|en = 'Exchange plans'"), 15, БиблиотекаКартинок.ПланОбмена);
	
	Для Каждого Зависимость Из Параметры.ЗависимостиОбъекта Цикл
		ДобавитьВложеннуюСтрокуДерева(Дерево, ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(Зависимость));
	КонецЦикла;
	
	Дерево.Колонки.Удалить(Дерево.Колонки["ПолноеИмя"]);
	Дерево.Колонки.Удалить(Дерево.Колонки["Класс"]);
	
	УдаляемыеСтроки = Новый Массив();
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.Строки.Количество() = 0 Тогда
			УдаляемыеСтроки.Добавить(СтрокаДерева);
		Иначе
			СтрокаДерева.Строки.Сортировать("Представление");
		КонецЕсли;
	КонецЦикла;
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Дерево.Строки.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ОбъектыМетаданных");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьКорневуюСтрокуДерева(Дерево,Знач ПолноеИмя, Знач Представление, Знач Класс, Знач Картинка)
	
	НоваяСтрока = Дерево.Строки.Добавить();
	НоваяСтрока.ПолноеИмя = ПолноеИмя;
	НоваяСтрока.Представление = Представление;
	НоваяСтрока.Класс = Класс;
	НоваяСтрока.Картинка = Картинка;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВложеннуюСтрокуДерева(Дерево, Знач ОбъектМетаданных)
	
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	СтруктураИмени = СтрРазделить(ПолноеИмя, ".");
	КлассОбъекта = СтруктураИмени[0];
	
	СтрокаВладелец = Неопределено;
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.ПолноеИмя = КлассОбъекта Тогда
			СтрокаВладелец = СтрокаДерева;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаВладелец = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неизвестный объект метаданных: %1';
				|en = 'Unknown metadata object: %1'"), ПолноеИмя);
	КонецЕсли;
	
	НоваяСтрока = СтрокаВладелец.Строки.Добавить();
	
	НоваяСтрока.Представление = ОбъектМетаданных.Представление();
	НоваяСтрока.Класс = СтрокаВладелец.Класс;
	НоваяСтрока.Картинка = СтрокаВладелец.Картинка;
	
КонецПроцедуры

#КонецОбласти