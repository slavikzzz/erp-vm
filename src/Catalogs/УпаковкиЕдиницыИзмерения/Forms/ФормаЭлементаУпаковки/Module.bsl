#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ВыполняетсяЗапись;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РазрешенаСменаРодителя");

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УпаковкиНоменклатуры", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Знаменатель <> 0 
		И Объект.ТипУпаковки <> ПредопределенноеЗначение("Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто")
		И Объект.Числитель / Объект.Знаменатель = 1
		И (Модифицированность
			Или (Не ЗначениеЗаполнено(Объект.Ссылка)))  Тогда 
		Если Не ЕстьЕдиничнаяУпаковкаСЕдиницейИзмерения(Объект.Ссылка, Объект.Владелец, Объект.ЕдиницаИзмерения) 
			И НЕ ВыполняетсяЗапись Тогда
			
			Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
				ТекстСообщения = НСтр("ru = 'Для номенклатуры ""%Владелец%"" уже создана упаковка с коэффициентом 1 и единицей измерения ""%ЕдиницаИзмерения%"".';
										|en = 'The item ""%Владелец%"" already has a packaging unit measured in %ЕдиницаИзмерения% with the 1:1 ratio.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Для набора упаковок ""%Владелец%"" уже создана упаковка с коэффициентом 1 и единицей измерения ""%ЕдиницаИзмерения%"".?';
										|en = 'The packaging group ""%Владелец%"" already has a packaging unit measured in %ЕдиницаИзмерения% with the 1:1 ratio.'");
			КонецЕсли;
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Владелец%", 		   Строка(Объект.Владелец));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмерения%", Строка(Объект.ЕдиницаИзмерения));
			
			Отказ = Истина;
			
			Кнопки = Новый СписокЗначений();
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать';
														|en = 'Save'")); 
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не записывать';
														|en = 'Discard'"));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект), 
				ТекстСообщения, 
				Кнопки,
				,
				,
				НСтр("ru = 'Дублирование единичной упаковки';
					|en = 'Packaging unit duplicate'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяЗапись = Истина;
	Записать();
	ВыполняетсяЗапись = Ложь;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВысотаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура ШиринаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура БезразмернаяПриИзменении(Элемент)
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ТипоразмерПриИзменении(Элемент)
	ТипоразмерПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура КоэффициентПриИзменении(Элемент)
	ОтработатьЛогикуСвязиРеквизитов();
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
		
	Объект.Наименование = ОбновитьНаименование(Объект.ТипУпаковки, Объект.ЕдиницаИзмерения, Объект.Числитель, Объект.Знаменатель, ЕдиницаИзмеренияВладельца);
	НастроитьФорму();

КонецПроцедуры

&НаКлиенте
Процедура ТипУпаковкиПриИзменении(Элемент)
	Если Объект.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковокНоменклатуры.Разупаковка") Тогда
		Объект.ПоставляетсяВМногооборотнойТаре  = Ложь;
		Объект.НоменклатураМногооборотнаяТара   = Неопределено;
		Объект.ХарактеристикаМногооборотнаяТара = Неопределено;
		ХарактеристикиИспользуются = Ложь;
	КонецЕсли;
	
	ОтработатьЛогикуСвязиРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	ОтработатьЛогикуСвязиРеквизитов();	
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	ОтработатьЛогикуСвязиРеквизитов();	
КонецПроцедуры

&НаКлиенте
Процедура ПоставляетсяВМногооборотнойТареПриИзменении(Элемент)
	
	Если Не Объект.ПоставляетсяВМногооборотнойТаре Тогда
		Объект.НоменклатураМногооборотнаяТара   = Неопределено;
		Объект.ХарактеристикаМногооборотнаяТара = Неопределено;
		Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = 0;
		ВариантПодбораТары = 0;
		ХарактеристикиИспользуются = Ложь;
	КонецЕсли;
	
	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураМногооборотнаяТараПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Объект.ХарактеристикаМногооборотнаяТара);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Объект.НоменклатураМногооборотнаяТара);
	СтруктураСтроки.Вставить("Характеристика", Объект.ХарактеристикаМногооборотнаяТара);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	Объект.НоменклатураМногооборотнаяТара = СтруктураСтроки.Номенклатура;
	Объект.ХарактеристикаМногооборотнаяТара = СтруктураСтроки.Характеристика;
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;

	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ШиринаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ШиринаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ГлубинаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ВысотаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ВысотаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ОбъемЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ОбъемЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Объем"));
КонецПроцедуры

&НаКлиенте
Процедура ВесЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ВесЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Вес"));
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияНажатие(ИмяПоля, СтандартнаяОбработка, ТипИзмеряемойВеличины)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЕдиницаИзмеренияНажатиеЗавершение", ЭтотОбъект, Новый Структура("ИмяПоля", ИмяПоля));
	
	Отбор = Новый Структура;
	Отбор.Вставить("ТипИзмеряемойВеличины", ТипИзмеряемойВеличины);
	
	ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.ФормаВыбора",
				Новый Структура("Отбор,ТекущаяСтрока", Отбор, Объект[ИмяПоля]),
				ЭтотОбъект,
				,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Объект[ДополнительныеПараметры.ИмяПоля] = Результат;
		Модифицированность = Истина;
		
		Если ДополнительныеПараметры.ИмяПоля = "ОбъемЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ГлубинаЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ШиринаЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ВысотаЕдиницаИзмерения" Тогда
			
			ПересчитатьОбъем();	
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.Форма.РазблокированиеРеквизитовУпаковки",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФорму()
	
	ИспользоватьМногооборотнуюТару         = ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару");
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьОрдерныеСклады             = ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныеСклады");
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Элементы.Владелец.Заголовок = НСтр("ru = 'Номенклатура';
											|en = 'Items'");
		Элементы.ДекорацияПредупреждение.Видимость = Ложь;
	Иначе
		Элементы.Владелец.Заголовок = НСтр("ru = 'Набор упаковок';
											|en = 'Packaging group'");
		Элементы.ДекорацияПредупреждение.Видимость = Истина;
	КонецЕсли;

	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
		ПредставлениеЕдиницыИзмерения = Строка(Объект.ЕдиницаИзмерения);
	Иначе
		ПредставлениеЕдиницыИзмерения =  НСтр("ru = '<ед. изм. по классификатору>';
												|en = '<Unit from classifier>'");
	КонецЕсли;
	
	ТекстПредставления = НСтр("ru = '1 %ЕдиницаПоКлассификатору% состоит из';
								|en = 'Single %ЕдиницаПоКлассификатору% contains'");
	ТекстПредставления = СтрЗаменить(ТекстПредставления, "%ЕдиницаПоКлассификатору%", ПредставлениеЕдиницыИзмерения);
	ПунктВыбора = Элементы.ТипУпаковки1.СписокВыбора.НайтиПоЗначению(Перечисления.ТипыУпаковокНоменклатуры.Конечная);
	ПунктВыбора.Представление = ТекстПредставления;
	
	ТекстПредставления = НСтр("ru = '1 %ЕдиницаПоКлассификатору% состоит из';
								|en = 'Single %ЕдиницаПоКлассификатору% contains'");
	ТекстПредставления = СтрЗаменить(ТекстПредставления, "%ЕдиницаПоКлассификатору%", ПредставлениеЕдиницыИзмерения);
	ПунктВыбора = Элементы.ТипУпаковки2.СписокВыбора.НайтиПоЗначению(Перечисления.ТипыУпаковокНоменклатуры.Составная);
	ПунктВыбора.Представление = ТекстПредставления;
	
	ТекстПредставления = НСтр("ru = '1 %ЕдиницаИзмеренияВладельца% состоит из';
								|en = 'Single %ЕдиницаИзмеренияВладельца% contains'");
	ТекстПредставления = СтрЗаменить(ТекстПредставления, "%ЕдиницаИзмеренияВладельца%", ЕдиницаИзмеренияВладельца);
	ПунктВыбора = Элементы.ТипУпаковки3.СписокВыбора.НайтиПоЗначению(Перечисления.ТипыУпаковокНоменклатуры.Разупаковка);
	ПунктВыбора.Представление = ТекстПредставления;
	
	Если ИспользоватьОрдерныеСклады Тогда
		
		ТекстПредставления = НСтр("ru = 'Входит в состав %ЕдиницаИзмеренияВладельца% в количестве';
									|en = 'Part of %ЕдиницаИзмеренияВладельца% in quantity of'");
		ТекстПредставления = СтрЗаменить(ТекстПредставления, "%ЕдиницаИзмеренияВладельца%", ЕдиницаИзмеренияВладельца);
		ПунктВыбора = Элементы.ТипУпаковки4.СписокВыбора.НайтиПоЗначению(Перечисления.ТипыУпаковокНоменклатуры.ТоварноеМесто);
		ПунктВыбора.Представление = ТекстПредставления;
		
	КонецЕсли;
	
	Элементы.ТипУпаковки4.Видимость        = ИспользоватьОрдерныеСклады;
	Элементы.КоличествоУпаковок1.Видимость = ИспользоватьОрдерныеСклады;
	Элементы.ЕдиницаИзмерения1.Видимость   = ИспользоватьОрдерныеСклады;
	
	Элементы.ТипУпаковки3.Видимость                       = Не Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(ЕдиницаИзмеренияВладельца);
	Элементы.Знаменатель.Видимость                        = Элементы.ТипУпаковки3.Видимость;
	Элементы.НадписьЗнаменательЕдиницаИзмерения.Видимость = Элементы.ТипУпаковки3.Видимость;
	Элементы.ДекорацияРазупаковка.Видимость               = Элементы.ТипУпаковки3.Видимость;
	
	Элементы.Числитель.Доступность = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Конечная;
	Элементы.Числитель.Родитель.Доступность = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Конечная;
	
	Элементы.КоличествоУпаковок.Доступность          = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная;
	Элементы.КоличествоУпаковок.Родитель.Доступность = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная;
	
	Элементы.Знаменатель.Доступность = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Разупаковка;
	Элементы.Знаменатель.Родитель.Доступность = Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Разупаковка;
	
	Элементы.КоличествоУпаковок1.Доступность 	= (Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.ТоварноеМесто);
	Элементы.ЕдиницаИзмерения1.Доступность 		= (Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.ТоварноеМесто);
	
	Элементы.ПоставляетсяВМногооборотнойТаре.Видимость   = ИспользоватьМногооборотнуюТару;
	Элементы.ПоставляетсяВМногооборотнойТаре.Доступность = Объект.ТипУпаковки <> Перечисления.ТипыУпаковокНоменклатуры.Разупаковка;
	
	Элементы.НоменклатураМногооборотнаяТара.Видимость   = Объект.ПоставляетсяВМногооборотнойТаре;
	Элементы.ХарактеристикаМногооборотнаяТара.Видимость = Объект.ПоставляетсяВМногооборотнойТаре
														  И ИспользоватьХарактеристикиНоменклатуры;
	Элементы.ХарактеристикаМногооборотнаяТара.Доступность = ХарактеристикиИспользуются;
	Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.Видимость = Объект.ПоставляетсяВМногооборотнойТаре;
	Элементы.ВариантыПодбораТары.Видимость = Объект.ПоставляетсяВМногооборотнойТаре И ИспользоватьМногооборотнуюТару;
		
	Элементы.Высота.Доступность  = НЕ Объект.Безразмерная;
	Элементы.Глубина.Доступность = НЕ Объект.Безразмерная;
	Элементы.Ширина.Доступность  = НЕ Объект.Безразмерная;
	Элементы.Объем.Доступность   = НЕ Объект.Безразмерная;
		
	Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.МаксимальноеЗначение = ?(Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная,
																						Объект.КоличествоУпаковок-1,
																						Объект.Числитель);
																						
	Элементы.ВариантПодбораТарыПолностью.СписокВыбора[0].Представление = СформироватьСтрокуВариантаПодбораТары(0);
	Элементы.ВариантПодбораТарыЧастично.СписокВыбора[0].Представление = СформироватьСтрокуВариантаПодбораТары(1);
																							
	Если Объект.МинимальноеКоличествоУпаковокМногооборотнойТары > 0 Тогда
		ВариантПодбораТары = 1;	
		Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.Доступность = Истина;
	Иначе
		ВариантПодбораТары = 0;
		Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.Доступность = Ложь;
	КонецЕсли;
	
	Если ТипЕдиницыИзмеренияВладельца = Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук Тогда 																					
		Элементы.Числитель.МинимальноеЗначение = 1;
	Иначе
		Элементы.Числитель.МинимальноеЗначение = 0.001;
	КонецЕсли;
	 
	Элементы.ВесЕдиницаИзмерения.Доступность = ПравоДоступа("Редактирование", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	Элементы.ОбъемЕдиницаИзмерения.Доступность = ПравоДоступа("Редактирование", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	Элементы.ГлубинаЕдиницаИзмерения.Доступность = ПравоДоступа("Редактирование", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	Элементы.ШиринаЕдиницаИзмерения.Доступность = ПравоДоступа("Редактирование", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	Элементы.ВысотаЕдиницаИзмерения.Доступность = ПравоДоступа("Редактирование", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОтработатьЛогикуСвязиРеквизитов()
	
	Справочники.УпаковкиЕдиницыИзмерения.ОтработатьЛогикуСвязиРеквизитов(Объект);
	Объект.Наименование = ОбновитьНаименование(Объект.ТипУпаковки, Объект.ЕдиницаИзмерения, Объект.Числитель, Объект.Знаменатель, ЕдиницаИзмеренияВладельца );
	Если Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная Тогда
		Если Объект.КоличествоУпаковок < Объект.МинимальноеКоличествоУпаковокМногооборотнойТары Тогда
			Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = Объект.КоличествоУпаковок;
		КонецЕсли;
	Иначе
		Если Объект.Числитель < Объект.МинимальноеКоличествоУпаковокМногооборотнойТары Тогда
			Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = Объект.Числитель;
		КонецЕсли;
	КонецЕсли;
	
	НастроитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПересчитатьОбъем()
	
	Если Объект.ШиринаЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()
		Или Объект.ГлубинаЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()
		Или Объект.ВысотаЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()
		Или Объект.ОбъемЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка() Тогда
		
		Объект.Объем = 0;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(&ШиринаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ШиринаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентШирина,
		|	ВЫРАЗИТЬ(&ВысотаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ВысотаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентВысота,
		|	ВЫРАЗИТЬ(&ГлубинаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ГлубинаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентГлубина,
		|	ВЫРАЗИТЬ(&ОбъемЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ОбъемЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентОбъем";
		
		Запрос.УстановитьПараметр("ШиринаЕдиницаИзмерения", 	Объект.ШиринаЕдиницаИзмерения);
		Запрос.УстановитьПараметр("ВысотаЕдиницаИзмерения", 	Объект.ВысотаЕдиницаИзмерения);
		Запрос.УстановитьПараметр("ГлубинаЕдиницаИзмерения", 	Объект.ГлубинаЕдиницаИзмерения);
		Запрос.УстановитьПараметр("ОбъемЕдиницаИзмерения", 		Объект.ОбъемЕдиницаИзмерения);		
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			Объект.Объем = Объект.Высота * Выборка.КоэффициентВысота * Объект.Глубина * Выборка.КоэффициентГлубина * Объект.Ширина * Выборка.КоэффициентШирина / Выборка.КоэффициентОбъем;	
		КонецЦикла;
		
	КонецЕсли;
	
		
КонецПроцедуры

&НаСервере
Процедура ТипоразмерПриИзмененииСервер()
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Типоразмер, "Глубина, ГлубинаЕдиницаИзмерения, Ширина, ШиринаЕдиницаИзмерения, Высота, ВысотаЕдиницаИзмерения, Объем, ОбъемЕдиницаИзмерения, Безразмерная");
	ЗаполнитьЗначенияСвойств(Объект, Результат);
	НастроитьФорму();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновитьНаименование(ТипУпаковки, ЕдиницаИзмерения, Числитель, Знаменатель, ЕдиницаИзмеренияВладельца)
	Возврат Справочники.УпаковкиЕдиницыИзмерения.СформироватьНаименование(ТипУпаковки, ЕдиницаИзмерения, Числитель, Знаменатель, ЕдиницаИзмеренияВладельца);	
КонецФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбновитьКоэффициентРодителя();	
 	СтруктураРезультат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, 
		Новый Структура("ЕдиницаИзмерения, ТипИзмеряемойВеличины", "ЕдиницаИзмерения", "ЕдиницаИзмерения.ТипИзмеряемойВеличины"));
	ЕдиницаИзмеренияВладельца = СтруктураРезультат.ЕдиницаИзмерения;
	ТипЕдиницыИзмеренияВладельца = СтруктураРезультат.ТипИзмеряемойВеличины;
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.НоменклатураМногооборотнаяТара);
	НастроитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоэффициентРодителя()
	
	Если Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная Тогда
		Результат = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(Объект.Родитель,
			Неопределено,
			"Числитель, Знаменатель");
		ЧислительРодителя = Результат.Числитель;
		ЗнаменательРодителя = Результат.Знаменатель;
	Иначе
		ЧислительРодителя = 1;
		ЗнаменательРодителя = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьЕдиничнаяУпаковкаСЕдиницейИзмерения(Ссылка, Владелец, ЕдиницаИзмерения)
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	&ТекстЗапросаКоэффициентУпаковки КАК КоличествоЕдиничныхУпаковок,
	|	УпаковкиНоменклатуры.Владелец,
	|	УпаковкиНоменклатуры.Ссылка
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|ГДЕ
	|	&ТекстЗапросаКоэффициентУпаковки = 1
	|	И УпаковкиНоменклатуры.ПометкаУдаления = ЛОЖЬ
	|	И УпаковкиНоменклатуры.Владелец = &Владелец
	|	И УпаковкиНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("УпаковкиНоменклатуры", Неопределено));
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЕдиницаИзмерения);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Возврат	Ложь;
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.Ссылка = Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВариантПодбораТарыПриИзмененииНаСервере()
	
	Если ВариантПодбораТары =0 Тогда
		Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = 0;
		Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.Доступность = Ложь;
	Иначе 
		Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = ?(Объект.МинимальноеКоличествоУпаковокМногооборотнойТары = 0,1,Объект.МинимальноеКоличествоУпаковокМногооборотнойТары);
		Элементы.МинимальноеКоличествоУпаковокМногооборотнойТары.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПодбораТарыПриИзменении(Элемент)
	ВариантПодбораТарыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция СформироватьСтрокуВариантаПодбораТары(НомерВарианта)
	
	СтрВарианта = "";
	КоличествоЕдиницВУпаковке = 0;
	Если Объект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная Тогда
		КоличествоЕдиницВУпаковке  = Объект.КоличествоУпаковок;	
		ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель, "ЕдиницаИзмерения");
	Иначе
		КоличествоЕдиницВУпаковке  = Объект.Числитель;	
		ЕдиницаИзмерения = ЕдиницаИзмеренияВладельца;
	КонецЕсли;
	Если НомерВарианта = 0 Тогда
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВладельца) Тогда
			СтрВарианта = СтрШаблон(Нстр("ru = ' полностью (%1 %2)';
										|en = ' in full (%1 %2)'"),КоличествоЕдиницВУпаковке,ЕдиницаИзмерения);	
		Иначе
			СтрВарианта = СтрШаблон(Нстр("ru = ' полностью (%1)';
										|en = ' in full (%1)'"),КоличествоЕдиницВУпаковке);
		КонецЕсли;
	ИначеЕсли НомерВарианта = 1 Тогда
		СтрВарианта = НСтр("ru = ' начиная с';
							|en = ' starting with'");		
	КонецЕсли;
	Элементы.НадписьЕдиницаИзмерения.Заголовок = СтрШаблон(Нстр("ru = '%1';
																|en = '%1'"),ЕдиницаИзмерения);

	Возврат СтрВарианта;
	
КонецФункции

&НаКлиенте
Процедура ВариантПодбораТарыЧастичноПриИзменении(Элемент)
	ВариантПодбораТарыПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

ВыполняетсяЗапись = Ложь;

#КонецОбласти
