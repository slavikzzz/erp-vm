#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользованиеГрафикаРаботы = 1 И Объект.Календарь.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Календарь"" не заполнено.';
								|en = '""Calendar"" is required.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Календарь", "Объект", Отказ);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.ДлительностьПереналадки.УстановитьДлительностьПереналадки(ТекущийОбъект.Ссылка,,, ВремяПереналадки);
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВидыРабочихЦентров");

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ИспользованиеГрафикаРаботы = 0 Тогда
		ТекущийОбъект.Календарь = Справочники.Календари.ПустаяСсылка();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" И Источник = Объект.Ссылка Тогда
		// Нужно прочитать время, т.к. оно записывается при записи вида РЦ
		ПрочитатьВремяПереналадки();
		
	ИначеЕсли ИмяСобытия = "Запись_СтруктураПредприятия" Тогда
		ПрочитатьПараметрыПодразделения();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланироватьРаботуРабочихЦентровПриИзменении(Элемент)
	
	ЗаполнитьПараметрыВидаРЦ();
	
	УправлениеВидимостью(ЭтотОбъект);
	
	ОчиститьРеквизитыЕслиНеПланироватьРаботу();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьГрафикПодразделенияПриИзменении(Элемент)
	
	Если ИспользованиеГрафикаРаботы = 0 И НЕ Объект.Календарь.Пустая() Тогда
		Объект.Календарь = ПредопределенноеЗначение("Справочник.Календари.ПустаяСсылка");
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИндивидуальныйГрафикПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПараметрыПланированияРаботыВГрафике(Команда)
	
	Если Объект.Подразделение.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Для изменения параметров необходимо выбрать подразделение.';
								|en = 'To change the parameters, select a business unit.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Подразделение", "Объект");
		Возврат;
	КонецЕсли; 
	
	ДанныеОбъекта = Новый Структура("КоличествоРабочихЦентров,ЕдиницаИзмеренияДоступностиРЦ,КонтрольДоступности,
										|МаксимальнаяДоступностьРЦ,МинимальныйЗначимыйБуфер,
										|УчитыватьДоступностьПоГрафикуРаботы,ВводитьДоступностьДляВидаРЦ");
										
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Вставить("ИнтервалПланирования", ИнтервалПланирования);
	ДанныеОбъекта.Вставить("НаименованиеВидаРЦ", Объект.Наименование);

	ОписаниеОповещения = Новый ОписаниеОповещения("ПараметрыПланированияРаботыВГрафикеЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура("ДанныеОбъекта", ДанныеОбъекта);
	ОткрытьФорму("Справочник.ВидыРабочихЦентров.Форма.ПараметрыПланированияРаботыВГрафике", ПараметрыФормы,,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПараметрыПланированияРаботыРЦ(Команда)
	
	Если Объект.Подразделение.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Для изменения параметров необходимо выбрать подразделение.';
								|en = 'To change the parameters, select a business unit.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Подразделение", "Объект");
		Возврат;
	КонецЕсли; 
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("Подразделение");
	ДанныеОбъекта.Вставить("ПараллельнаяЗагрузка");
	ДанныеОбъекта.Вставить("ЕдиницаИзмеренияЗагрузки");
	ДанныеОбъекта.Вставить("ВариантЗагрузки");
	ДанныеОбъекта.Вставить("ВремяРаботы");
	ДанныеОбъекта.Вставить("ЕдиницаИзмерения");
	ДанныеОбъекта.Вставить("ЕдиницаВремениПереналадки");
	ДанныеОбъекта.Вставить("ИспользуютсяВариантыНаладки");
											
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.Вставить("ВремяПереналадки", ВремяПереналадки);
	ДанныеОбъекта.Вставить("НаименованиеВидаРЦ", Объект.Наименование);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПараметрыПланированияРаботыРЦЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура("ДанныеОбъекта", ДанныеОбъекта);
	ОткрытьФорму("Справочник.ВидыРабочихЦентров.Форма.ПараметрыПланированияРаботыРЦ", ПараметрыФормы,,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ПараметрыПроцедуры = ОбщегоНазначенияУТКлиент.ПараметрыРазрешенияРедактированияРеквизитовОбъекта();
	ПараметрыПроцедуры.ОповещениеОРазблокировке = Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма, ПараметрыПроцедуры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// ОтметкаНезаполненного для Календарь
	#Область КалендарьОтметка
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Календарь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользованиеГрафикаРаботы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПрочитатьНастройкиПроизводства();
	
	НастроитьПанельНавигации();
	
	ПрочитатьПараметрыПодразделения();
	
	// Нужно прочитать время, т.к. оно записывается при записи вида РЦ
	ПрочитатьВремяПереналадки();
	
	Если НЕ Объект.Календарь.Пустая() Тогда
		ИспользованиеГрафикаРаботы = 1;
	Иначе
		ИспользованиеГрафикаРаботы = 0;
	КонецЕсли; 
	
	ЗаполнитьПараметрыВидаРЦ();
	
	УправлениеДоступностью(ЭтотОбъект);
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Форма.Элементы.Календарь.Доступность = (Форма.ИспользованиеГрафикаРаботы = 1);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиПроизводства()
	
	НастройкиПодсистемы = ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиПодсистемы);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПанельНавигации()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьВариантыНаладки", Объект.ИспользуютсяВариантыНаладки);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(ЭтаФорма, СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВидаРЦ()

	ЖирныйШрифт = Новый Шрифт(,, Истина);
	
	// Заполним параметры планирования в графике производства
	СтрокиИнформации = Новый Массив;
	
	Если Объект.УчитыватьДоступностьПоГрафикуРаботы Тогда
		
		// Учитывается ограничение
		ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- В графике производства учитывается ограничение доступности';
															|en = '- Capacity restriction is considered in the production schedule'"));
		СтрокиИнформации.Добавить(ТекстИнформации);
		
		// Как вводится доступность
		СтрокиИнформации.Добавить(Символы.ПС);
		Если Объект.ВводитьДоступностьДляВидаРЦ Тогда
			ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- Доступность вводится для вида РЦ';
																|en = '- Capacity is entered for work center type'"));
		Иначе
			ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- Доступность определяется по графикам работы РЦ';
																|en = '- Capacity is determined by work center schedules'"));
		КонецЕсли;
		СтрокиИнформации.Добавить(ТекстИнформации);
		
		// Минимальный значимый буфер
		Если Объект.МинимальныйЗначимыйБуфер <> 0 Тогда
			СтрокиИнформации.Добавить(Символы.ПС);
			ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = '- Минимальный значимый буфер: %1%';
											|en = '- Minimum significant buffer: %1%'"),
										Объект.МинимальныйЗначимыйБуфер);
			ТекстИнформации = Новый ФорматированнаяСтрока(ТекстИнформации);
			СтрокиИнформации.Добавить(ТекстИнформации);
		КонецЕсли;
		
	Иначе
		
		// Не учитывается ограничение
		ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- В графике производства не учитывается ограничение доступности';
															|en = '- Capacity restriction is not considered in the production schedule'"));
		СтрокиИнформации.Добавить(ТекстИнформации);
		
		// Минимальный значимый буфер
		Если Объект.МинимальныйЗначимыйБуфер <> 0 Тогда
			СтрокиИнформации.Добавить(Символы.ПС);
			ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = '- Минимальный значимый буфер: %1%';
											|en = '- Minimum significant buffer: %1%'"),
										Объект.МинимальныйЗначимыйБуфер);
			ТекстИнформации = Новый ФорматированнаяСтрока(ТекстИнформации);
			СтрокиИнформации.Добавить(ТекстИнформации);
		КонецЕсли;
		
	КонецЕсли;
	
	ИнформацияОПланированииРаботыВГрафикеПроизводства = Новый ФорматированнаяСтрока(СтрокиИнформации);
	
	// Заполним параметры планирования работы РЦ
	Если Объект.ПланироватьРаботуРабочихЦентров Тогда
		
		СтрокиИнформации = Новый Массив;
		
		Если Объект.ПараллельнаяЗагрузка Тогда
			
			// Допускается параллельная загрузка
			Если Объект.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный Тогда
				ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- Допускается синхронная загрузка';
																	|en = '- Synchronous load is allowed'"));
			Иначе
				ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- Допускается асинхронная загрузка';
																	|en = '- Asynchronous load is allowed'"));
			КонецЕсли; 
			СтрокиИнформации.Добавить(ТекстИнформации);
			
		Иначе
			
			// Не допускается параллельная загрузка
			ТекстИнформации = Новый ФорматированнаяСтрока(НСтр("ru = '- Не допускается параллельная загрузка';
																|en = '- Parallel load is not allowed'"));
			СтрокиИнформации.Добавить(ТекстИнформации);
			
		КонецЕсли; 
		
		// Использование вариантов наладки
		Если Объект.ИспользуютсяВариантыНаладки Тогда
			
			СтрокиИнформации.Добавить(Символы.ПС);
			КоличествоВариантовНаладки = КоличествоВведенныхВариантовНаладки(Объект.Ссылка);
			Если КоличествоВариантовНаладки <> 0 Тогда
				ПараметрыПредметаИсчисления = НСтр("ru = 'вариант, варианта, вариантов, м,,,,,0';
													|en = 'option, options,,,0'");
				ВариантовПрописью = ПолучитьПредметИсчисления(КоличествоВариантовНаладки, ПараметрыПредметаИсчисления);
				
				ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = '- Используется %1 %2 наладки';
												|en = '- %1 %2 setups are used'"),
											Формат(КоличествоВариантовНаладки, "ЧГ=0"),
											ВариантовПрописью);
			Иначе
				ТекстИнформации = НСтр("ru = '- Используются варианты наладки (требуется ввести)';
										|en = '- Setup settings are used (mandatory parameter)'");
			КонецЕсли;
			ТекстИнформации = Новый ФорматированнаяСтрока(ТекстИнформации);
			СтрокиИнформации.Добавить(ТекстИнформации);
			
			// Время переналадки
			Если ВремяПереналадки <> 0 Тогда
				СтрокиИнформации.Добавить(Символы.ПС);
				ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
											НСтр("ru = '- Время переналадки %1%2 при переходе на любой вариант наладки с любых других';
												|en = '- Changeover time %1%2 for changeover between any setup settings'"),
											Формат(ВремяПереналадки, "ЧГ=0"),
											Объект.ЕдиницаВремениПереналадки);
				ТекстИнформации = Новый ФорматированнаяСтрока(ТекстИнформации);
				СтрокиИнформации.Добавить(ТекстИнформации);
			КонецЕсли;
			
		КонецЕсли;
		
		ИнформацияОПланированииРаботыРЦ = Новый ФорматированнаяСтрока(СтрокиИнформации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	Объект = Форма.Объект;
	
	Форма.Элементы.ИнформацияОПланированииРаботыВГрафикеПроизводства.Видимость = Объект.УчитыватьДоступностьПоГрафикуРаботы;
	
	Форма.Элементы.ГруппаПланироватьРаботуРабочихЦентров.Видимость = Объект.ПланироватьРаботуРабочихЦентров;
	
	Форма.Элементы.ГруппаРезервДоступностиРеквизиты.Видимость = Объект.УчитыватьДоступностьПоГрафикуРаботы
		ИЛИ Объект.ПланироватьРаботуРабочихЦентров;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоВведенныхВариантовНаладки(ВидРабочегоЦентра)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ВариантыНаладки.Ссылка), 0) КАК Количество
	|ИЗ
	|	Справочник.ВариантыНаладки КАК ВариантыНаладки
	|ГДЕ
	|	ВариантыНаладки.Владелец = &ВидРабочегоЦентра
	|	И НЕ ВариантыНаладки.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВидРабочегоЦентра", ВидРабочегоЦентра);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	КонецЕсли;
	
	Возврат 0;

КонецФункции

&НаСервере
Функция ПолучитьПредметИсчисления(Число, ПараметрыПредметаИсчисления)
	
	ЧислоПрописью = ЧислоПрописью(Число,, ПараметрыПредметаИсчисления);
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, " ", Символы.ПС);
	
	Возврат СтрПолучитьСтроку(ЧислоПрописью, СтрЧислоСтрок(ЧислоПрописью));
	
КонецФункции

&НаКлиенте
Процедура ПараметрыПланированияРаботыВГрафикеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РезультатЗакрытия);
	
	ЗаполнитьПараметрыВидаРЦ();
	
	ОчиститьРеквизитыЕслиНеПланироватьРаботу();
	
	УправлениеДоступностью(ЭтотОбъект);
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПланированияРаботыРЦЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РезультатЗакрытия);
	ВремяПереналадки = РезультатЗакрытия.ВремяПереналадки;
	
	ПараметрыПланированияРаботыРЦЗавершениеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПараметрыПланированияРаботыРЦЗавершениеНаСервере()

	ЗаполнитьПараметрыВидаРЦ();
	
	НастроитьПанельНавигации();

КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()

	ИнтервалПланированияДоИзменения = ИнтервалПланирования; 
	
	ПрочитатьПараметрыПодразделения();

	Если ИнтервалПланирования <> ИнтервалПланированияДоИзменения Тогда
		
		// Нужно сбросить параметры которые не подходят для нового интервала планирования
		Если ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
			СписокИзмененныхНастроек = "";
			Если Объект.УчитыватьДоступностьПоГрафикуРаботы
				И Объект.ВводитьДоступностьДляВидаРЦ Тогда
				
				Объект.ВводитьДоступностьДляВидаРЦ = Ложь;
				СписокИзмененныхНастроек = СписокИзмененныхНастроек
											+ ?(СписокИзмененныхНастроек <> "",", ","")
											+ НСтр("ru = 'Доступность в графике производства';
													|en = 'Capacity in production schedule'");
			КонецЕсли;
			
			Если СписокИзмененныхНастроек <> "" Тогда
				ТекстСообщения = НСтр("ru = 'В выбранном подразделении используется интервал планирования ""Час"", поэтому следующие настройки были изменены:';
										|en = 'The ""Hour"" planning interval is used in the selected business unit, that is why the following settings were changed:'")
								+ СписокИзмененныхНастроек + ".";
								
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
		Объект.МаксимальнаяДоступностьРЦ = 1;
		Объект.ЕдиницаИзмеренияДоступностиРЦ = Перечисления.ЕдиницыИзмеренияВремени.Час;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.День Тогда
		Объект.МаксимальнаяДоступностьРЦ = 24;
		Объект.ЕдиницаИзмеренияДоступностиРЦ = Перечисления.ЕдиницыИзмеренияВремени.Час;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Неделя Тогда
		Объект.МаксимальнаяДоступностьРЦ = 7;
		Объект.ЕдиницаИзмеренияДоступностиРЦ = Перечисления.ЕдиницыИзмеренияВремени.Сутки;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Месяц Тогда
		Объект.МаксимальнаяДоступностьРЦ = 30;
		Объект.ЕдиницаИзмеренияДоступностиРЦ = Перечисления.ЕдиницыИзмеренияВремени.Сутки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПараметрыПодразделения()
	
	ПараметрыПодразделения = ПроизводствоСерверПовтИсп.ПараметрыПроизводственногоПодразделения(Объект.Подразделение);
	ИнтервалПланирования = ПараметрыПодразделения.ИнтервалПланирования;
	
	ЗаполнитьПараметрыМаксимальнойДоступности();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРеквизитыЕслиНеПланироватьРаботу()

	Если НЕ Объект.УчитыватьДоступностьПоГрафикуРаботы И НЕ Объект.ПланироватьРаботуРабочихЦентров Тогда
		Объект.РезервДоступности = 0;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяПереналадки()

	ВремяПереналадки = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДлительностьПереналадки.ВремяПереналадки
	|ИЗ
	|	РегистрСведений.ДлительностьПереналадки КАК ДлительностьПереналадки
	|ГДЕ
	|	ДлительностьПереналадки.ВидРабочегоЦентра = &ВидРабочегоЦентра
	|	И ДлительностьПереналадки.ТекущийВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка)
	|	И ДлительностьПереналадки.СледующийВариантНаладки = ЗНАЧЕНИЕ(Справочник.ВариантыНаладки.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("ВидРабочегоЦентра", Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ВремяПереналадки = Выборка.ВремяПереналадки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыМаксимальнойДоступности()

	Если ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
		МаксимумЧасовСтрокой = НСтр("ru = '1 час';
									|en = '1 hour'");
		ИнтервалВСекундах = 3600;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.День Тогда
		МаксимумЧасовСтрокой = НСтр("ru = '24 часа';
									|en = '24 hours'");
		ИнтервалВСекундах = 86400;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Неделя Тогда
		МаксимумЧасовСтрокой = НСтр("ru = '7 дней';
									|en = '7 days'");
		ИнтервалВСекундах = 604800;
	ИначеЕсли ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Месяц Тогда
		МаксимумЧасовСтрокой = НСтр("ru = '30 дней';
									|en = '30 days'");
		ИнтервалВСекундах = 2592000; // 30 дней
	КонецЕсли;
	
	ЗаголовокНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '(максимум %1)';
			|en = '(%1 maximum)'"),
		МаксимумЧасовСтрокой);
	
	Элементы.ДекорацияМаксимальнаяДоступностьРЦ.Заголовок = ЗаголовокНадписи;
	
	СписокВыбора = Элементы.ЕдиницаИзмеренияДоступностиРЦ.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(Перечисления.ЕдиницыИзмеренияВремени.Минута);
	СписокВыбора.Добавить(Перечисления.ЕдиницыИзмеренияВремени.Час);
	Если ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Неделя
		Или ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Месяц Тогда
		СписокВыбора.Добавить(Перечисления.ЕдиницыИзмеренияВремени.Сутки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
