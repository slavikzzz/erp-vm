
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("КлючНазначенияИспользования") 
		И ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		КлючНазначенияИспользования = Параметры.КлючНазначенияИспользования;
	ИначеЕсли Параметры.Свойство("КлючНазначенияФормы")
		И Не ПустаяСтрока(Параметры.КлючНазначенияФормы) Тогда
		КлючНазначенияИспользования = Параметры.КлючНазначенияФормы;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Договор) = Тип("СправочникСсылка.ДоговорыКредитовИДепозитов") Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СписокДокументов.ТекстЗапроса, "ВЫБРАТЬ NULL КАК Ссылка", ТекстЗапросаДокументыДоговоровКредитовДепозитов());
		СвойстваСписка.ОсновнаяТаблица = СписокДокументов.ОсновнаяТаблица;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументов, СвойстваСписка);
		
	//++ НЕ УТ
	ИначеЕсли ТипЗнч(Параметры.Договор) = Тип("СправочникСсылка.ДоговорыАренды") Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СписокДокументов.ТекстЗапроса, "ВЫБРАТЬ NULL КАК Ссылка", ТекстЗапросаДокументыДоговоровАренды());
		СвойстваСписка.ОсновнаяТаблица = СписокДокументов.ОсновнаяТаблица;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументов, СвойстваСписка);
	//-- НЕ УТ
	ИначеЕсли ТипЗнч(Параметры.Договор) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями")
		Или ТипЗнч(Параметры.Договор) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СписокДокументов.ТекстЗапроса, "ВЫБРАТЬ NULL КАК Ссылка", ТекстЗапросаДокументыДоговоровКонтрагентов());
		СвойстваСписка.ОсновнаяТаблица = СписокДокументов.ОсновнаяТаблица;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументов, СвойстваСписка);
		
	ИначеЕсли ТипЗнч(Параметры.Договор) = Тип("СправочникСсылка.ДоговорыЭквайринга") Тогда
		
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		
		СвойстваСписка.ТекстЗапроса = СтрЗаменить(СписокДокументов.ТекстЗапроса, "ВЫБРАТЬ NULL КАК Ссылка", ТекстЗапросаДокументыДоговоровЭквайринга());
		СвойстваСписка.ОсновнаяТаблица = СписокДокументов.ОсновнаяТаблица;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументов, СвойстваСписка);
	КонецЕсли;
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Договор", Параметры.Договор);
	
	//++ Локализация
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(СписокДокументов);
	
	Если ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.СписокДокументовЕстьОшибкиПроверкиКонтрагентов.Видимость = Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	//-- Локализация
	
	ТипДоговора = ТипЗнч(Параметры.Договор);
	ТипыДокументовПоДоговору = Новый Массив;
	
	ТипыДокументов = СписокДокументов.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	Для каждого ТипДокумента Из ТипыДокументов.Типы() Цикл
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипДокумента);
		РеквизитДоговор = МетаданныеДокумента.Реквизиты.Найти("Договор");
		Если РеквизитДоговор <> Неопределено И РеквизитДоговор.Тип.СодержитТип(ТипДоговора) Тогда
			ТипыДокументовПоДоговору.Добавить(ТипДокумента);
		КонецЕсли;
	КонецЦикла;
	
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.РасходныйКассовыйОрдер"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.НачисленияКредитовИДепозитов"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ОперацияПоПлатежнойКарте"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ОтчетБанкаПоОперациямЭквайринга"));
	//++ НЕ УТ
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ЗаключениеДоговораАренды"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ПоступлениеУслугПоАренде"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ВыкупАрендованныхОС"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ПрекращениеДоговораАренды"));
	ТипыДокументовПоДоговору.Добавить(Тип("ДокументСсылка.ИзменениеУсловийДоговораАренды"));
	//-- НЕ УТ
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ТипыДокументовПоДоговору.Количество() Тогда
		ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ТипыДокументовПоДоговору);
		ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
		ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодДатаНачалаДатаОкончанияПриИзменении(Элемент)
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Период.ДатаНачала);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("КонецПериода", Период.ДатаОкончания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокДокументовПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	ОбщегоНазначенияУТ.ОбработатьМультиязычнуюКолонкуСписка(Строки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокДокументов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДокументов.Дата", "СписокДокументовДата");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоПериоду()
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Период.ДатаНачала);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("КонецПериода", Период.ДатаОкончания);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ДокументыПоДоговору";
	
КонецФункции

&НаСервере
Функция ТекстЗапросаДокументыДоговоровКредитовДепозитов()
	
	ТекстЗапроса = "
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка
	|	ИЗ
	|		РегистрСведений.РеестрДокументов КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Договор = &Договор
	|		И НЕ ДанныеДокумента.ДополнительнаяЗапись
	|";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорКредитаДепозита = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходныйКассовыйОрдер) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорКредитаДепозита = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.СписаниеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорКредитаДепозита = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриходныйКассовыйОрдер) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорКредитаДепозита = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорКредитаДепозита = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.НачисленияКредитовИДепозитов) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.НачисленияКредитовИДепозитов КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.НачисленияКредитовИДепозитов.Начисления КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.Договор = &Договор)
		|";
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

//++ НЕ УТ

&НаСервере
Функция ТекстЗапросаДокументыДоговоровАренды()
	
	ТекстЗапроса = "
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка
	|	ИЗ
	|		РегистрСведений.РеестрДокументов КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Договор = &Договор
	|		И НЕ ДанныеДокумента.ДополнительнаяЗапись
	|";
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ИзменениеУсловийДоговораАренды) Тогда

		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ИзменениеУсловийДоговораАренды КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.НовыйДоговор = &Договор
		|		И ДанныеДокумента.НовыйДоговор <> ЗНАЧЕНИЕ(Справочник.ДоговорыАренды.ПустаяСсылка)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорАренды = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходныйКассовыйОрдер) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорАренды = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.СписаниеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорАренды = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ДоговорАренды = &Договор)
		|";
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ВводОстатковВнеоборотныхАктивов2_4) Тогда
		
		ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ" + "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВводыОстатков.Ссылка 
		|ИЗ
		|	(
		|		ВЫБРАТЬ
		|			ВводОстатковВнеоборотныхАктивов2_4ОС.Ссылка КАК Ссылка
		|		ИЗ
		|			Документ.ВводОстатковВнеоборотныхАктивов2_4.ОС КАК ВводОстатковВнеоборотныхАктивов2_4ОС
		|		ГДЕ
		|			ВводОстатковВнеоборотныхАктивов2_4ОС.Договор = &Договор
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВводОстатковВнеоборотныхАктивов2_4АрендованныеОС.Ссылка
		|		ИЗ
		|			Документ.ВводОстатковВнеоборотныхАктивов2_4.АрендованныеОС КАК ВводОстатковВнеоборотныхАктивов2_4АрендованныеОС
		|		ГДЕ
		|			ВводОстатковВнеоборотныхАктивов2_4АрендованныеОС.Договор = &Договор
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВводОстатковВнеоборотныхАктивов2_4РасчетыПоДоговорамАренды.Ссылка
		|		ИЗ
		|			Документ.ВводОстатковВнеоборотныхАктивов2_4.РасчетыПоДоговорамАренды КАК ВводОстатковВнеоборотныхАктивов2_4РасчетыПоДоговорамАренды
		|		ГДЕ
		|			ВводОстатковВнеоборотныхАктивов2_4РасчетыПоДоговорамАренды.Договор = &Договор
		|	) КАК ВводыОстатков
		|";
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ


&НаСервере
Функция ТекстЗапросаДокументыДоговоровКонтрагентов()
	
	ТекстЗапроса = "
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка
	|	ИЗ
	|		РегистрСведений.РеестрДокументов КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Договор = &Договор
	|		И НЕ ДанныеДокумента.ДополнительнаяЗапись
	|";
	
	ТекстыЗапросовРасшифровки = Новый Массив;	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств) Тогда
				
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.РасходныйКассовыйОрдер) Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.СписаниеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.СписаниеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПриходныйКассовыйОрдер) Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств) Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|			ОБЪЕДИНИТЬ ВСЕ
		|		
		|			ВЫБРАТЬ
		|				ДанныеТабличнойЧасти.Ссылка
		|			ИЗ
		|				Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|			ГДЕ
		|				ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|				И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);
		
	КонецЕсли;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ОперацияПоПлатежнойКарте) Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = "
		|ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ОперацияПоПлатежнойКарте КАК ДанныеДокумента
		|	ГДЕ
		|		ДанныеДокумента.Ссылка В
		|				(ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Объект = &Договор
		|		
		|				ОБЪЕДИНИТЬ ВСЕ
		|		
		|				ВЫБРАТЬ
		|					ДанныеТабличнойЧасти.Ссылка
		|				ИЗ
		|					Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК ДанныеТабличнойЧасти
		|				ГДЕ
		|					ДанныеТабличнойЧасти.Ссылка = ДанныеДокумента.Ссылка
		|					И ДанныеТабличнойЧасти.ОбъектРасчетов.Договор = &Договор)
		|";
		ТекстыЗапросовРасшифровки.Добавить(ТекстЗапросаРасшифровкиПлатежа);

	КонецЕсли;
	
	Если ТекстыЗапросовРасшифровки.Количество() Тогда
		
		ТекстЗапросаРасшифровкиПлатежа = СтрСоединить(ТекстыЗапросовРасшифровки, "ОБЪЕДИНИТЬ ВСЕ"); //@Query-part
		
		// ОБЪЕДИНИТЬ, потому что Ссылки из расшифровок платежа могут дублировать Ссылки из реестра.
		ТекстЗапроса = ТекстЗапроса + " ОБЪЕДИНИТЬ " + "
		|ВЫБРАТЬ
		|		ДанныеРасшифровкиПлатежа.Ссылка КАК Ссылка
		|	ИЗ
		|	(" //@query-part
		+ ТекстЗапросаРасшифровкиПлатежа + ") КАК ДанныеРасшифровкиПлатежа 
		|";
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции

&НаСервере
Функция ТекстЗапросаДокументыДоговоровЭквайринга()
	
	ТекстЗапроса = "
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Ссылка
	|	ИЗ
	|		РегистрСведений.РеестрДокументов КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Договор = &Договор
	|		И НЕ ДанныеДокумента.ДополнительнаяЗапись
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
