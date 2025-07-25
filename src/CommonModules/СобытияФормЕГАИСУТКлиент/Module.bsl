#Область ОбработчикиСобытийЭлементовФормы

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - ЭлементФормы     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - дополнительные параметры для обработчика события
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента" Тогда
		
		Если Элемент = Форма.Элементы.НомерВходящегоДокумента
		ИЛИ Элемент = Форма.Элементы.ДатаВходящегоДокумента Тогда
			НайтиТТНЕГАИС(Форма);
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Элемент = "ПробитьЧекПослеПроведения" Тогда
			
			ЕстьАлкогольнаяПродукция = Ложь;
			Если Форма.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС Тогда
				Для Каждого СтрокаТЧ Из Форма.Объект.Товары Цикл
					Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТЧ, "ВидПродукцииИС")
						И СтрокаТЧ.ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная")
						И СтрокаТЧ.МаркируемаяПродукция Тогда
						ЕстьАлкогольнаяПродукция = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			ДополнительныеПараметры.Вставить("ЕстьАлкогольнаяПродукция", ЕстьАлкогольнаяПродукция);
			
		ИначеЕсли Элемент = "ПечатьЧека_ПослеОткрытияЧека" Тогда
			
			Если ДополнительныеПараметры.ДополнительныеПараметры.ЕстьАлкогольнаяПродукция Тогда
				
				ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
				ПередатьЧекВЕГАИС(Форма, ДополнительныеПараметры, Ложь);
				
			КонецЕсли;
			
		ИначеЕсли Элемент = "ПечатьЧека_ПослеОшибкиПечатиЧека" Тогда
			
			Если ДополнительныеПараметры.ДополнительныеПараметры.ЕстьАлкогольнаяПродукция Тогда
				
				ПередатьЧекВЕГАИС(Форма, ДополнительныеПараметры, Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Справочник.НастройкиРМК.Форма.ФормаЭлемента" Тогда
		Если Поле = Форма.Элементы.КассыККМПараметрыПодключенияЕГАИС
			И Форма.ЧтениеНастройкиОбменаЕГАИС Тогда
			
			ТекущаяСтрока = Форма.Элементы.КассыККМ.ТекущиеДанные;
			
			Если ТекущаяСтрока = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ОткрытьФормуПараметрыПодключенияЕГАИС(Форма, ТекущаяСтрока);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		ЭлементНоменклатураЕГАИС = Форма.Элементы.ТоварыНоменклатураЕГАИС;
		Если Элемент.ТекущийЭлемент = ЭлементНоменклатураЕГАИС Тогда
			
			ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
			Если ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ЭлементНоменклатураЕГАИС.СписокВыбора.ЗагрузитьЗначения(ТекущиеДанные.НоменклатураДляВыбора.ВыгрузитьЗначения());
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПриобретениеТоваровУслуг

Процедура ОбработатьВыборТТНЕГАИСИзСписка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ТребуетсяСвязатьОрганизацию", Ложь);
	ДополнительныеПараметры.Вставить("Ссылка",                      Результат);
	
	ОбработатьВыборТТНЕГАИС(ДополнительныеПараметры, Истина);
	
КонецПроцедуры

Процедура СформироватьТекстДокументаЕГАИС(Форма, ОчищатьВместоИзмененияВидимости = Ложь) Экспорт
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС");
	Объект = Форма[ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект];
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС.ДокументОснование");
	ЭлементИнтерфейса  = Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы];
	
	Если Форма.ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента" Тогда
		ТекстГиперссылки = ИнтеграцияЕГАИСВызовСервераУТ.ТекстДокументаЕГАИСВПриобретенииТоваров(Объект, Форма.ТТНВходящаяЕГАИС);
	Иначе
		ТекстГиперссылки = ИнтеграцияЕГАИСВызовСервера.ТекстДокументаЕГАИС(Объект.Ссылка);
	КонецЕсли;
	
	ЭлементИнтерфейса.Видимость = ОчищатьВместоИзмененияВидимости ИЛИ ЗначениеЗаполнено(ТекстГиперссылки);
	Форма[ПараметрыИнтеграции.ИмяРеквизитаФормы] = ТекстГиперссылки;
	
КонецПроцедуры

Процедура ОбработатьВыборТТНЕГАИС(ДополнительныеПараметры, СопоставлятьКлассификаторы = Истина) Экспорт
	
	Если ДополнительныеПараметры.ТребуетсяСвязатьОрганизацию Тогда
		
		ЗаписатьСвязьКонтрагентаПартнераИОрганизацииЕГАИС(ДополнительныеПараметры);
		
	КонецЕсли;
	
	РезультатПроверки = ИнтеграцияЕГАИСВызовСервера.ПроверитьСопоставлениеКлассификаторов(ДополнительныеПараметры.Ссылка);
	Если Не РезультатПроверки.ЕстьНеСопоставленныеТовары
		И Не РезультатПроверки.ЕстьНеСопоставленныеОрганизации Тогда
		
		Если ИнтеграцияЕГАИСВызовСервера.ЕстьРасхожденияМеждуДокументомПоступленияИТТНЕГАИС(ДополнительныеПараметры.Ссылка, ДополнительныеПараметры.Форма.Объект) Тогда
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения(
					"ОбработатьОтветНаВопросОРасхожденияхПослеВыбораДокументаПоступления",
					ЭтотОбъект,
					ДополнительныеПараметры),
				НСтр("ru = 'В товарах выбранного поступления есть алкогольная продукция, которой нет в ТТН. Продолжить выбор?';
					|en = 'В товарах выбранного поступления есть алкогольная продукция, которой нет в ТТН. Продолжить выбор?'"),
				РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			ОбработатьОтветНаВопросОРасхожденияхПослеВыбораДокументаПоступления(КодВозвратаДиалога.Да, ДополнительныеПараметры);
			
		КонецЕсли;
		
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("ru = 'Сопоставить';
													|en = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена';
													|en = 'Отмена'"));
		
		ПоказатьВопрос(
				Новый ОписаниеОповещения(
					"ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС", ЭтотОбъект, ДополнительныеПараметры),
				НСтр("ru = 'В документе найдены несопоставленные элементы классификаторов ЕГАИС.
				     |Сопоставить классификаторы?';
				     |en = 'В документе найдены несопоставленные элементы классификаторов ЕГАИС.
				     |Сопоставить классификаторы?'"),
				Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСвязьКонтрагентаПартнераИОрганизацииЕГАИС(ПараметрыСвязи)
	
	ИнтеграцияЕГАИСВызовСервера.ЗаписатьСвязьКонтрагентаПартнераИОрганизацииЕГАИС(
		ПараметрыСвязи.ОрганизацияЕГАИС,
		ПараметрыСвязи.Контрагент,
		ПараметрыСвязи.Партнер);
	
КонецПроцедуры

Процедура ОбработатьОтветНаВопросОРасхожденияхПослеВыбораДокументаПоступления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСВызовСервера.ЗаписатьСвязьДокументаПоступленияИТТНЕГАИС(
		ДополнительныеПараметры.Ссылка, 
		ДополнительныеПараметры.Форма.Объект.Ссылка);
		
	СформироватьТекстДокументаЕГАИС(ДополнительныеПараметры.Форма);
	
КонецПроцедуры

Процедура ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ДополнительныеПараметры.Ссылка);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ТоварноТранспортныеНакладные", МассивСсылок);
	
	СобытияФормЕГАИСКлиент.ОткрытьФормуСопоставленияКлассификаторовЕГАИС(
		ДополнительныеПараметры.Форма,
		Новый ОписаниеОповещения(
			"ОбработатьРезультатСопоставленияКлассификаторовЕГАИС",
			ЭтотОбъект,
			ДополнительныеПараметры),
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

Процедура ОбработатьРезультатСопоставленияКлассификаторовЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	ОбработатьВыборТТНЕГАИС(ДополнительныеПараметры, Ложь);
	
КонецПроцедуры

Процедура НайтиТТНЕГАИС(Форма)
	
	Объект = Форма.Объект;
	Если Форма.ВестиСведенияДляДекларацийПоАлкогольнойПродукции
		И ЗначениеЗаполнено(Объект.НомерВходящегоДокумента)
		И ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента)
		И ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		Результат = ИнтеграцияЕГАИСВызовСервера.НайтиТТНЕГАИС(Объект.Контрагент, Объект.НомерВходящегоДокумента, Объект.ДатаВходящегоДокумента);
		
		Если ЗначениеЗаполнено(Результат.Ссылка) Тогда
			
			ТекстВопроса = НСтр("ru = 'Связать Товарно-транспортную накладную ЕГАИС %1 от %2 (Поставщик ЕГАИС - %3) с текущим поступлением? %4';
								|en = 'Связать Товарно-транспортную накладную ЕГАИС %1 от %2 (Поставщик ЕГАИС - %3) с текущим поступлением? %4'");
			
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", Результат.НомерТТН);
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%2", Результат.ДатаТТН);
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%3", Результат.ОрганизацияЕГАИС);
			
			Если Результат.ТребуетсяСвязатьОрганизацию Тогда
				
				Результат.Вставить("Контрагент", Объект.Контрагент);
				Результат.Вставить("Партнер",    Объект.Партнер);
				
				Уточнение = Символы.ПС + НСтр("ru = 'Поставщик ЕГАИС будет связан с поставщиком %1.';
												|en = 'Поставщик ЕГАИС будет связан с поставщиком %1.'");
				Уточнение = СтрЗаменить(Уточнение, "%1", Объект.Контрагент);
				
				ТекстВопроса = СтрЗаменить(ТекстВопроса, "%4", Уточнение);
				
			Иначе
				ТекстВопроса = СтрЗаменить(ТекстВопроса, "%4", "");
			КонецЕсли;
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ОбработатьОтветНаВопросОСвязыванииСВыбраннойТТНЕГАИС",
					ЭтотОбъект,
					Результат),
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОтветНаВопросОСвязыванииСВыбраннойТТНЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОбработатьВыборТТНЕГАИС(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаИПодборПродукцииЕГАИС

Процедура ПриЗакрытииФормыПроверкиИПодбора(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Если Не ЭтоАдресВременногоХранилища(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ЗакрытиеФормыПроверкиИПодбораЕГАИС", Результат, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиРМК

Процедура ОткрытьФормуПараметрыПодключенияЕГАИС(Форма, ТекущаяСтрока) Экспорт
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.СтатусПодключенияКЕгаис)
		И ТекущаяСтрока.СтатусПодключенияКЕгаис <>"НеУказываются" Тогда
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторФСРАР", ТекущаяСтрока.ИдентификаторФСРАР);
		Параметры.Вставить("РабочееМесто",       Форма.Объект.РабочееМесто);
		
		Если ТекущаяСтрока.СтатусПодключенияКЕгаис = "Настроить" Тогда
			
			ПараметрыОткрытияФормы = Новый Структура("ЗначенияЗаполнения", Параметры);
			
		Иначе
			
			Параметры.Вставить("УдалитьИзмерениеОрганизация", Неопределено);
			Параметры.Вставить("УдалитьИзмерениеСклад", Неопределено);
			
			ЗначениеКлюча = Новый Массив;
			ЗначениеКлюча.Добавить(Параметры);
			
			КлючЗаписи = Новый (Тип("РегистрСведенийКлючЗаписи.НастройкиОбменаЕГАИС"), ЗначениеКлюча);
			ПараметрыОткрытияФормы = Новый Структура("Ключ", КлючЗаписи);
			
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.НастройкиОбменаЕГАИС.ФормаЗаписи", 
			ПараметрыОткрытияФормы,
			Форма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбменСЕГАИСИзРМК

Процедура ПослеПередачиЧекаЕГАИС(Изменения, ПараметрыВыполнения) Экспорт
	
	ЕстьОшибки = (Изменения.Количество() <> 1);
	
	Ошибки = Новый Массив;
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Свойство("ТекстОшибки") И ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			ЕстьОшибки = Истина;
			Ошибки.Добавить(ЭлементДанных.ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	Если Ошибки.Количество() > 0 Тогда
		Ошибки.Вставить(0, НСтр("ru = 'В процессе передачи данных в ЕГАИС возникли ошибки:';
								|en = 'В процессе передачи данных в ЕГАИС возникли ошибки:'"));
	КонецЕсли;
	ОписаниеОшибки = СтрСоединить(Ошибки, Символы.ПС);
	
	Если ПараметрыВыполнения.Свойство("ЭтоОтменаЧека") Тогда
		
		Если ЕстьОшибки Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
		КонецЕсли;
		
	Иначе
		
		ПараметрыВыполнения.ПродолжитьПечать = Не ЕстьОшибки;
		ПараметрыВыполнения.ОписаниеОшибки   = ОписаниеОшибки;
		
		ПараметрыВыполнения.Вставить("АдресЧека",   Изменения[0].ИдентификаторЗапроса);
		ПараметрыВыполнения.Вставить("ПодписьЧека", Изменения[0].Подпись);
		
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОповещениеПродолжения, ПараметрыВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередатьЧекВЕГАИС(Форма, ДополнительныеПараметры, ЭтоОтменаЧека)
	
	ДанныеЧека  = ДополнительныеПараметры.ПараметрыВыполнения;
	
	НомерСмены = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДанныеЧека.НомерСмены);
	Если НомерСмены = 0 Тогда
		НомерСмены = 1;
	КонецЕсли;
	
	НомерЧека = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДанныеЧека.НомерЧека);
	Если НомерЧека = 0 Тогда
		НомерЧека = 1;
	КонецЕсли;
	Если ЭтоОтменаЧека Тогда
		НомерЧека = НомерЧека + 1000000;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("НомерСмены",    НомерСмены);
	ПараметрыОперации.Вставить("НомерЧека",     НомерЧека);
	ПараметрыОперации.Вставить("СерийныйНомер", Форма.ПараметрыКассыККМ.СерийныйНомер);
	
	Если ДанныеЧека.Свойство("ЗаводскойНомерФН") И ЗначениеЗаполнено(ДанныеЧека.ЗаводскойНомерФН) Тогда
		ПараметрыОперации.СерийныйНомер = ДанныеЧека.ЗаводскойНомерФН;
	КонецЕсли;
	
	ОперацияЕГАИС = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные");
	Если ЭтоОтменаЧека Тогда
		ОперацияЕГАИС = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию");
		ДанныеЧека.Вставить("ЭтоОтменаЧека");
	КонецЕсли;
	
	ОбменДаннымиЕГАИСКлиент.ПередатьНемедленно(
		Форма.Объект.Ссылка,
		ОперацияЕГАИС,
		ПараметрыОперации,
		Новый ОписаниеОповещения("ПослеПередачиЧекаЕГАИС", ЭтотОбъект, ДанныеЧека),
		Форма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти
