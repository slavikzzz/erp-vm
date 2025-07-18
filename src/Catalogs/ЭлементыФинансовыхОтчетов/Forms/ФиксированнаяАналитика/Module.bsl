
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтаФорма);
	ИсточникиЗначений.Загрузить(ДанныеОбъекта.ИсточникиЗначений);
	
	ДеревоЭлементов = ДанныеФормыВЗначение(Параметры.ЭлементыОтчета, Тип("ДеревоЗначений"));
	АдресЭлементовОтчета = ПоместитьВоВременноеХранилище(ДеревоЭлементов, УникальныйИдентификатор);
	
	Заголовок = Параметры.ВидЭлемента;
	ЭтоСтроки = Параметры.ЭтоСтроки;

	Справочники.ЭлементыФинансовыхОтчетов.ЗаполнитьПредставлениеДополнительныхПолей(Объект, Элементы.ВыборДополнительныхПолей);
	
	ИспользуетсяИерархияЗначений = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ИспользуетсяИерархияЗначенийАналитики(
		ВидАналитики);
	Параметры.Свойство("ИспользоватьДляВводаПлана", ИспользоватьДляВводаПлана);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ЭтоАналитикаПрочее Тогда
		Если РазрешитьРедактирование Тогда
			ТипАналитики = 1;
		Иначе
			ТипАналитики = 2;
		КонецЕсли;
	Иначе
		ТипАналитики = 0;
	КонецЕсли;

	ДанныеВидаАналитики = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидАналитики, "ТипЗначения, ДополнительноеСвойство");
	Если ДанныеВидаАналитики.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектов") Тогда
		ВладелецЗначений = ДанныеВидаАналитики.ДополнительноеСвойство;
		СвязьПараметров = Новый СвязьПараметраВыбора("Отбор.Владелец", "ВладелецЗначений");
		Массив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СвязьПараметров);
		Элементы.ЗначениеАналитики.СвязиПараметровВыбора = Новый ФиксированныйМассив(Массив);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАналитикаПрочее Тогда
		Если РазрешитьРедактирование И ИсточникВсеЭлементы Тогда
			Объект.НаименованиеДляПечати = БюджетнаяОтчетностьКлиентСервер.ПредставлениеПрочейАналитикиБюджетирования(
				ВидАналитики,
				?(ВыводитьИерархиюЭлементов, "ВсеИерархия", "Все"));
		Иначе
			Если РазрешитьРедактирование Тогда
				Объект.НаименованиеДляПечати = БюджетнаяОтчетностьКлиентСервер.ПредставлениеПрочейАналитикиБюджетирования(
					ВидАналитики,
					"ДобавляемыеИПрочие");
			Иначе
				Объект.НаименованиеДляПечати = БюджетнаяОтчетностьКлиентСервер.ПредставлениеПрочейАналитикиБюджетирования(
					ВидАналитики,
					"Прочие");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Объект.НаименованиеДляПечати = Строка(Объект.ЗначениеАналитики);
	КонецЕсли;
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресЭлементаВХранилище);
	ДанныеОбъекта.ИсточникиЗначений = ИсточникиЗначений.Выгрузить();
	ДанныеОбъекта.НаименованиеДляПечати = Объект.НаименованиеДляПечати; 
	ПоместитьВоВременноеХранилище(ДанныеОбъекта, АдресЭлементаВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Ошибки = Неопределено;
	
	Если Не ЭтоАналитикаПрочее Тогда
		Если Не ЗначениеЗаполнено(Объект.ЗначениеАналитики) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнено значение аналитики';
								|en = 'Dimension value is required'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"ЗначениеАналитики",
				ТекстОшибки, "");
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникиАналитикПоУмолчаниюПриИзменении(Элемент)
	
	Если ВыбранныеИсточникиЗначений Тогда
		ЗаполнитьИсточникиПоУмолчанию();
	КонецЕсли;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидАналитикиПриИзменении(Элемент)
	
	ПриИзмененииВидаАналитики();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникВсеЭлементыПриИзменении(Элемент)
	
	Если Не ИсточникВсеЭлементы Тогда
		ВыводитьИерархиюЭлементов = Ложь;
		Компоновщик.Настройки.Отбор.Элементы.Очистить();
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьИерархиюЭлементовПриИзменении(Элемент)
	
	ПриИзмененииВидаАналитики(ВыводитьИерархиюЭлементов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДополнительныхПолей(Команда)
	
	ПараметрыФормы = БюджетнаяОтчетностьВызовСервера.ПараметрыНастройкиДополнительныхПолей(Объект, ВидАналитики, ЭтоСтроки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновлениеДополнительныхПолей", ЭтаФорма);
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.НастройкаДополнительныхПолей", 
					ПараметрыФормы,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИсточники(Команда)
	
	ПараметрыВыбораИсточников = Новый Структура;
	ПараметрыВыбораИсточников.Вставить("АдресЭлементаВХранилище", АдресЭлементаВХранилище);
	ПараметрыВыбораИсточников.Вставить("АдресЭлементовОтчета",    АдресЭлементовОтчета);
	ПараметрыВыбораИсточников.Вставить("ИсточникиЗначений",       ИсточникиЗначений);
	ПараметрыВыбораИсточников.Вставить("Заполнение",              Истина);
	
	Оповещение = Новый ОписаниеОповещения("ВыборИсточниковЗначений", ЭтаФорма);
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.ИсточникиЗначений", ПараметрыВыбораИсточников
												,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ВыбратьИсточники.Доступность = ВыбранныеИсточникиЗначений;
	Если Элементы.ВыбратьИсточники.Доступность 
		И ИсточникиЗначений.Количество() Тогда
		Элементы.ВыбратьИсточники.Заголовок = НСтр("ru = 'Изменить источники (%1)';
													|en = 'Change sources (%1)'");
		Элементы.ВыбратьИсточники.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ВыбратьИсточники.Заголовок,
			ИсточникиЗначений.Количество());
	Иначе
		Элементы.ВыбратьИсточники.Заголовок = НСтр("ru = 'Не указаны';
													|en = 'Not specified'");
	КонецЕсли;
	
	Элементы.ЗначениеАналитики.Доступность = Не ЭтоАналитикаПрочее;
	Элементы.ЗначениеАналитики.АвтоОтметкаНезаполненного = Не ЭтоАналитикаПрочее;
	Элементы.ГруппаИсточники.Доступность = РазрешитьРедактирование;
	Элементы.ИсточникВсеЭлементы.Доступность = РазрешитьРедактирование;
	Элементы.ВыводитьИерархиюЭлементов.Доступность = ИсточникВсеЭлементы И ИспользуетсяИерархияЗначений;
	Элементы.ГруппаДополнительныйОтбор.Видимость = ВыводитьИерархиюЭлементов И ИспользоватьДляВводаПлана;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДополнительныеПоля(Результат)
	
	Объект.ДополнительныеПоля.Загрузить(ПолучитьИзВременногоХранилища(Результат));
	Справочники.ЭлементыФинансовыхОтчетов.ЗаполнитьПредставлениеДополнительныхПолей(Объект, Элементы.ВыборДополнительныхПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДополнительныхПолей(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДополнительныеПоля(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИсточниковЗначений(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИсточникиЗначений.Очистить();
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(ИсточникиЗначений, Результат, "Источник");
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсточникиПоУмолчанию()
	Кэш = Неопределено;
	
	РассчитанныеИсточникиЗначений = БюджетнаяОтчетностьРасчетКэшаСервер.ИсточникиЗначенийПоУмолчанию(Кэш, АдресЭлементовОтчета, АдресЭлементаВХранилище, Ложь); 
	ИсточникиЗначений.Загрузить(РассчитанныеИсточникиЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаАналитики(ЗагрузитьНастройкиОтбора = Истина)

	Компоновщик.Настройки.Отбор.Элементы.Очистить();

	Если ЗагрузитьНастройкиОтбора Тогда

		ИспользуетсяИерархияЗначений = ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ИспользуетсяИерархияЗначенийАналитики(
			ВидАналитики);

		Если ИспользуетсяИерархияЗначений И ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
			ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресЭлементаВХранилище);
			Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(ЭтотОбъект, Компоновщик,
				ДанныеОбъекта.ВидЭлемента, ДанныеОбъекта.ДополнительныйОтбор);
		КонецЕсли;

		Если Не ИспользуетсяИерархияЗначений Тогда
			ВыводитьИерархиюЭлементов = Ложь;
		КонецЕсли;

	КонецЕсли;

	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ТипАналитикиПриИзменении(Элемент)
	
	Если ТипАналитики = 2 Тогда //прочие значения
		ЭтоАналитикаПрочее = Истина;
		ИсточникВсеЭлементы = Ложь;
		РазрешитьРедактирование = Ложь;
	ИначеЕсли ТипАналитики = 1 Тогда //добавлять значения
		ЭтоАналитикаПрочее = Истина;
		РазрешитьРедактирование = Истина;
	ИначеЕсли ТипАналитики = 0 Тогда //фиксированное значение
		ЭтоАналитикаПрочее = Ложь;
		РазрешитьРедактирование = Ложь;
		ИсточникВсеЭлементы = Ложь;
	КонецЕсли;
	
	Если ЭтоАналитикаПрочее Тогда
		Объект.ЗначениеАналитики = БюджетированиеКлиентСервер.ПустоеЗначениеАналитики();
	КонецЕсли;
	
	УправлениеФормой();

КонецПроцедуры

#КонецОбласти