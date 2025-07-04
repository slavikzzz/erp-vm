#Область СлужебныеПроцедурыИФункции

#Область УчетВходящегоНДС

#Область РегистрацияСчетовФактурПолученных

// см. УчетНДСУПКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыПолученные
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыПолученные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "ОткрытьСписокСчетовФактурПолученных" Тогда
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
		СтруктураОтбор.Вставить("Организация",       ПараметрыРегистрации.Организация);
		СтруктураОтбор.Вставить("ПометкаУдаления",   Ложь);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		Если ПараметрыРегистрации.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
			ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаСписка", ПараметрыФормы, Форма);
		Иначе
			ОткрытьФорму("Документ.СчетФактураПолученный.ФормаСписка", ПараметрыФормы, Форма);
		КонецЕсли;
	ИначеЕсли НавигационнаяСсылка = "ОткрытьСчетФактуруПолученный" Тогда
		Ключ = УчетНДСРФВызовСервера.СчетФактураПолученныйПоОснованию(ПараметрыРегистрации);
		ПараметрыФормы = Новый Структура("Ключ", Ключ);
		Если ПараметрыРегистрации.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
			ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта", ПараметрыФормы, Форма);
		Иначе
			ОткрытьФорму("Документ.СчетФактураПолученный.ФормаОбъекта", ПараметрыФормы, Форма);
		КонецЕсли;
	ИначеЕсли НавигационнаяСсылка = "ОткрытьИнойДокументПодтвержденияНДС" Тогда
		Ключ = УчетНДСРФВызовСервера.ИнойДокументПодтвержденияНДСПоОснованию(ПараметрыРегистрации);
		ПараметрыФормы = Новый Структура("Ключ", Ключ);
		ОткрытьФорму("Документ.ИнойДокументПодтвержденияНДС.ФормаОбъекта", ПараметрыФормы, Форма);
	ИначеЕсли НавигационнаяСсылка = "ОткрытьЗаявлениеОВвозеТоваров" Тогда
		Ключ = УчетНДСРФВызовСервера.ЗаявлениеОВвозеТоваровПоОснованию(
					ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация);
		ПараметрыФормы = Новый Структура("Ключ", Ключ);
		ОткрытьФорму("Документ.ЗаявлениеОВвозеТоваров.ФормаОбъекта", ПараметрыФормы, Форма);
	ИначеЕсли НавигационнаяСсылка = "ВвестиНовыйСчетФактуру" Тогда
		ВвестиСчетФактуруПолученный(Форма, ПараметрыРегистрации);
	ИначеЕсли НавигационнаяСсылка = "ВвестиНовыйЗаявлениеОВвозеТоваров" Тогда
		ВвестиЗаявлениеОВвозеТоваров(Форма, ПараметрыРегистрации);
	ИначеЕсли НавигационнаяСсылка = "ОчиститьДокументПриобретения" Тогда
		Ключ = УчетНДСРФВызовСервера.СчетФактураПолученныйПоОснованию(ПараметрыРегистрации);
		УчетНДСРФВызовСервера.ОчиститьДокументПриобретенияВСчетеФактуреПолученномНалоговогоАгента(Ключ);
		Форма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ЗаконченоРедактированиеСчетаФактурыПолученного
Функция ЗаконченоРедактированиеСчетаФактурыПолученного(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;

	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураПолученный.Форма.ФормаДокумента"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураПолученный.Форма.ФормаСписка"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаДокумента"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаСписка"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаВыбора"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.ЗаявлениеОВвозеТоваров.Форма.ФормаДокумента"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.ЗаявлениеОВвозеТоваров.Форма.ФормаРабочееМесто" Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// см. УчетНДСУПКлиент.ВвестиСчетФактуруПолученный
Процедура ВвестиСчетФактуруПолученный(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиСчетФактуруПолученныйЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияУТКлиент.ВыполнитьОбработкуОповещенияПослеПроверкиПроведенностиДокумента(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиСчетФактуруПолученныйЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
		
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	ПараметрыОткрытия.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ПараметрыОткрытия.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	ПараметрыОткрытия.Вставить("Исправление",       ПараметрыРегистрации.ИсправлениеОшибок);
	ПараметрыОткрытия.Вставить("Корректировочный",  ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
	
	ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
	Если ПараметрыРегистрации.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
		
		// Проверяем, если по контрагенту и организации есть счета-фактуры по товарам в пути, то
		// выводим дополнительное окно для выбора таких счетов-фактур, иначе создаем новую счет-фактуру.
		
		СчетаФактурыВПути = УчетНДСРФВызовСервера.СчетаФактурыПоТоварамВПути(ПараметрыОткрытия);
		Если СчетаФактурыВПути.Количество() = 0 Тогда
			ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
		Иначе
			СтруктураОтбора = Новый Структура("Контрагент,Организация");
			ЗаполнитьЗначенияСвойств(СтруктураОтбора, ПараметрыОткрытия);
			СтруктураОтбора.Вставить("ДатаПереходаПраваСобственности", Дата(1,1,1));
			
			ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
			ДополнительныеПараметры.Вставить("ПараметрыФормы", ПараметрыФормы);
			
			Оповещение = Новый ОписаниеОповещения("ВыборСчетаФактурыВПутиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаВыбора", ПараметрыФормы,
				ДополнительныеПараметры.Форма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	Иначе
		ОткрытьФорму("Документ.СчетФактураПолученный.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборСчетаФактурыВПутиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта",
			ДополнительныеПараметры.ПараметрыФормы,
			ДополнительныеПараметры.Форма);
	Иначе
		УчетНДСРФВызовСервера.ОтразитьПолучениеТовараСОбратнымОбложениемНДС(
			Результат,
			ДополнительныеПараметры.ПараметрыФормы.ДокументОснование);
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Данные счета-фактуры успешно изменены';
														|en = 'The tax invoice data is successfully changed'"));
		Оповестить();
	КонецЕсли;
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ВвестиЗаявлениеОВвозеТоваров
Процедура ВвестиЗаявлениеОВвозеТоваров(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиЗаявлениеОВвозеТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияУТКлиент.ВыполнитьОбработкуОповещенияПослеПроверкиПроведенностиДокумента(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиЗаявлениеОВвозеТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
	
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
	
	ДанныеЗаявленияОВвозеТоваров = Новый Структура;
	ДанныеЗаявленияОВвозеТоваров.Вставить("ДокументОснование", ДокументОснование);
	ДанныеЗаявленияОВвозеТоваров.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ДанныеЗаявленияОВвозеТоваров.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Основание", ДанныеЗаявленияОВвозеТоваров);
	ПараметрыФормы.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
	
	ОткрытьФорму("Документ.ЗаявлениеОВвозеТоваров.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
	
КонецПроцедуры

#КонецОбласти

// Выводит печатную форму заявления о ввозе товаров из ЕАЭС.
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьЗаявлениеОВвозеТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ОбщегоНазначенияБПКлиент.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаявлениеОВвозеТоваров",
		"ЗаявлениеОВвозеТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);
	
КонецФункции

// Выводит печатную форму учета перемещения товаров документа "Заявление о ввозе товаров из ЕАЭС".
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьСтатистическаяФормаУчетаПеремещенияТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ОбщегоНазначенияБПКлиент.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаявлениеОВвозеТоваров",
		"СтатистическаяФормаУчетаПеремещенияТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);

КонецФункции

#КонецОбласти

#Область УчетИсходящегоНДС

#Область ФормированиеСчетовФактурВыданных

// см. УчетНДСУПКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыВыданные
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыВыданные(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт
	
	Если НавигационнаяСсылка = "ОткрытьСписокСчетовФактурВыданных" Тогда
		СтандартнаяОбработка = Ложь;
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
		СтруктураОтбор.Вставить("Организация",       ПараметрыРегистрации.Организация);
		СтруктураОтбор.Вставить("ПометкаУдаления",   Ложь);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		ОткрытьФорму("Документ.СчетФактураВыданный.ФормаСписка", ПараметрыФормы, Форма);
	ИначеЕсли НавигационнаяСсылка = "ОткрытьСчетФактуруВыданный" Тогда
		СтандартнаяОбработка = Ложь;
		Ключ = УчетНДСРФВызовСервера.СчетФактураВыданныйПоОснованию(
				ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация);
		ПараметрыФормы = Новый Структура("Ключ", Ключ);
		ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, Форма);
	ИначеЕсли НавигационнаяСсылка = "ВвестиНовыйСчетФактуруВыданный" Тогда
		СтандартнаяОбработка = Ложь;
		ВвестиСчетФактуруВыданный(Форма, ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ЗаконченоРедактированиеСчетаФактурыВыданного
Функция ЗаконченоРедактированиеСчетаФактурыВыданного(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокумента"
		  ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаСписка" Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// см. УчетНДСУПКлиент.ПечатьИсправительныхСчетовФактурПоИзмененнымДокументам
Процедура ПечатьИсправительныхСчетовФактурПоИзмененнымДокументам(ТаблицаИзмененныхДокументов, Форма) Экспорт
	
	МассивДокументов = Новый Массив;
	Для каждого Строка Из ТаблицаИзмененныхДокументов Цикл
		Если МассивДокументов.Найти(Строка.Документ) = Неопределено Тогда
			МассивДокументов.Добавить(Строка.Документ);
		КонецЕсли;
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьОбщихФорм",
		"СчетФактура",
		МассивДокументов,
		Форма, // ВладелецФормы
		Новый Структура("ПечатьВВалюте", Ложь)); // ПараметрыПечати
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ВвестиСчетФактуруВыданный
Процедура ВвестиСчетФактуруВыданный(Форма, ПараметрыРегистрации) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыРегистрации",  ПараметрыРегистрации);
	ДополнительныеПараметры.Вставить("ОткрыватьСуществующую", Ложь);
	ДополнительныеПараметры.Вставить("Форма",                 Форма);
	
	Оповещение = Новый ОписаниеОповещения("ВвестиСчетФактуруВыданныйЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияУТКлиент.ВыполнитьОбработкуОповещенияПослеПроверкиПроведенностиДокумента(Форма, Оповещение);
	
КонецПроцедуры

Процедура ВвестиСчетФактуруВыданныйЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыРегистрации = ДополнительныеПараметры.ПараметрыРегистрации;
		
	Если ЗначениеЗаполнено(ПараметрыРегистрации.Ссылка) Тогда
		ДокументОснование = ПараметрыРегистрации.Ссылка;
	Иначе
		ДокументОснование = ДополнительныеПараметры.Форма.Объект.Ссылка;
	КонецЕсли;
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	ПараметрыОткрытия.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ПараметрыОткрытия.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	ПараметрыОткрытия.Вставить("Исправление",       ПараметрыРегистрации.ИсправлениеОшибок);
	ПараметрыОткрытия.Вставить("Корректировочный",  ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
	ПараметрыОткрытия.Вставить("РеализацияЧерезКомиссионера",
													ПараметрыРегистрации.РеализацияЧерезКомиссионера);

	Если ПараметрыРегистрации.ИсправлениеОшибок Тогда 
		СчетаФактурыОснования = УчетНДСРФВызовСервера.ЗаполнитьСчетаФактурыОснования(ПараметрыОткрытия);
		Если СчетаФактурыОснования = Неопределено Тогда
			ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
			ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
		Иначе
			ТекстВопроса = НСтр("ru = 'По выбранным документам-основаниям необходимо выставить несколько исправленных счетов-фактур.';
								|en = 'Several adjusted tax invoices must be drawn by selected base documents.'") + Символы.ПС 
			+ НСтр("ru = 'Будет создано несколько исправленных счетов-фактур, в которых необходимо вручную заполнить сведения об исправлениях.';
					|en = 'Several corrected tax invoices will be created. Enter the information on corrections manually.'") + Символы.ПС 
			+ НСтр("ru = 'Создать отдельные документы?';
					|en = 'Do you want to create separate documents?'");
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("СчетаФактурыОснования", СчетаФактурыОснования);
			ДополнительныеПараметры.Вставить("ДокументОснование", ДокументОснование);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВвестиОтдельныеСчетаФактурыВыданныеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		КонецЕсли;
	Иначе
	
		ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
		ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВвестиОтдельныеСчетаФактурыВыданныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	СписокСчетовФактурОснования = Новый СписокЗначений;
	Для Каждого КлючИЗначение Из ДополнительныеПараметры.СчетаФактурыОснования Цикл 
		СписокСчетовФактурОснования.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	СписокСчетовФактурОснования.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	СчетаФактурыОснования = СписокСчетовФактурОснования.ВыгрузитьЗначения();
	
	Инд = 1;
	
	Для Каждого СчетФактураОснование Из СчетаФактурыОснования Цикл 
		
		СчетФактураИсправление = ДополнительныеПараметры.СчетаФактурыОснования.Получить(СчетФактураОснование);
		Если ЗначениеЗаполнено(СчетФактураИсправление) Тогда 
			Продолжить;
		КонецЕсли;
		
		ЭтоКорректировочныйСФ = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(СчетФактураОснование, "Корректировочный");
		
		Если Инд = 1
			И ЭтоКорректировочныйСФ Тогда
			ПараметрыСоздания = Новый Структура("Уникальность, РучнаяКорректировкаСуммДокумента", Истина, Истина);
			ПараметрыСоздания.Вставить("ДокументОснование", ДополнительныеПараметры.ДокументОснование);
			ПараметрыСоздания.Вставить("СозданНаОсновании", ДополнительныеПараметры.ДокументОснование);
			ПараметрыВыполнения = Новый Структура("ОписаниеКоманды", Новый Структура("МножественныйВыбор, ДополнительныеПараметры", Ложь, ПараметрыСоздания));
		Иначе
			ПараметрыВыполнения = Новый Структура("ОписаниеКоманды", Новый Структура("МножественныйВыбор, ДополнительныеПараметры", Ложь, Новый Структура("Уникальность, СозданНаОсновании", Истина, ДополнительныеПараметры.ДокументОснование)));
		КонецЕсли;
		
		КорректировочныйСчетФактура(СчетФактураОснование, ПараметрыВыполнения);
		
		Инд = Инд + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеСчетовФактурКомиссионеру
	
// см. УчетНДСУПКлиент.ОбработкаНавигационнойСсылкиСчетаФактурыКомиссионеру
Процедура ОбработкаНавигационнойСсылкиСчетаФактурыКомиссионеру(Форма, НавигационнаяСсылка, СтандартнаяОбработка, ПараметрыРегистрации) Экспорт

	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылка = "ОткрытьСписокСчетовФактурКомиссионеру" Тогда
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
		СтруктураОтбор.Вставить("Организация",       ПараметрыРегистрации.Организация);
		СтруктураОтбор.Вставить("ПометкаУдаления",   Ложь);
		СтруктураОтбор.Вставить("КОформлению",       Ложь);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		Если ПараметрыРегистрации.РеализацияЧерезКомиссионера Тогда
			ОбщегоНазначенияУТКлиент.ОткрытьФормуПослеПроверкиПроведенностиДокумента("Документ.СчетФактураВыданный.Форма.ФормаСпискаПоОтчетуКомиссионера",ПараметрыФормы, Форма);
		Иначе
			ОбщегоНазначенияУТКлиент.ОткрытьФормуПослеПроверкиПроведенностиДокумента("Документ.СчетФактураКомиссионеру.Форма.ФормаСпискаПоОтчетуКомиссионера",ПараметрыФормы, Форма);
		КонецЕсли;
	ИначеЕсли НавигационнаяСсылка = "ОткрытьСчетФактуруКомиссионеру" Тогда
		Ключ = УчетНДСРФВызовСервера.СчетФактураКомиссионеруПоОснованию(
					ПараметрыРегистрации.Ссылка, ПараметрыРегистрации.Организация, ПараметрыРегистрации.РеализацияЧерезКомиссионера);
		ПараметрыФормы = Новый Структура("Ключ", Ключ);
		Если ПараметрыРегистрации.РеализацияЧерезКомиссионера Тогда
			ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, Форма);
		Иначе
			ОткрытьФорму("Документ.СчетФактураКомиссионеру.ФормаОбъекта", ПараметрыФормы, Форма);
		КонецЕсли;
	ИначеЕсли НавигационнаяСсылка = "ОткрытьСчетаФактурыКомиссионеруКОформлению" Тогда
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
		СтруктураОтбор.Вставить("Организация",       ПараметрыРегистрации.Организация);
		СтруктураОтбор.Вставить("ПометкаУдаления",   Ложь);
		СтруктураОтбор.Вставить("КОформлению",       Истина);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		Если ПараметрыРегистрации.РеализацияЧерезКомиссионера Тогда
			ОбщегоНазначенияУТКлиент.ОткрытьФормуПослеПроверкиПроведенностиДокумента("Документ.СчетФактураВыданный.Форма.ФормаСпискаПоОтчетуКомиссионера", ПараметрыФормы, Форма);
		Иначе
			ОбщегоНазначенияУТКлиент.ОткрытьФормуПослеПроверкиПроведенностиДокумента("Документ.СчетФактураКомиссионеру.Форма.ФормаСпискаПоОтчетуКомиссионера", ПараметрыФормы, Форма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ЗаконченоРедактированиеСчетовФактурКомиссионеру
Функция ЗаконченоРедактированиеСчетовФактурКомиссионеру(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураКомиссионеру.Форма.ФормаДокумента"
	      ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураКомиссионеру.Форма.ФормаСписка"
	      ИЛИ ИсточникВыбора.ИмяФормы = "Документ.СчетФактураКомиссионеру.Форма.ФормаСпискаПоОтчетуКомиссионера" Тогда
		Результат = Истина;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область ВыборИОформлениеСчетовФактурДляОтчетаКомитенту

// см. УчетНДСУПКлиент.НачалоВыбораСчетаФактурыДляОтчетаКомитенту
Процедура НачалоВыбораСчетаФактурыДляОтчетаКомитенту(Элемент, ПараметрыВыбора, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ВыборСчетаФактурыВыданногоПокупателюКомиссионногоТовара", ПараметрыВыбора, Элемент);
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ОткрытьФормуОформленияСчетовФактурДляОтчетаКомитенту
Процедура ОткрытьФормуОформленияСчетовФактурДляОтчетаКомитенту(ПараметрыФормы, ФормаВладелец) Экспорт
	
	ОткрытьФорму("Документ.СчетФактураВыданный.Форма.ФормаОформленияСчетовФактур", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ЗаконченоОформлениеСчетовФактурВыданных
Функция ЗаконченоОформлениеСчетовФактурВыданных(РезультатВыбора, ИсточникВыбора) Экспорт
	
	Результат = Ложь;
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаОформленияСчетовФактур" Тогда
		Результат = Истина;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПеречислениеНДСВБюджетПоОтдельнымОперациям

// см. УчетНДСУПКлиент.ОткрытьФормуПодбораСчетовФактурТребующихОплатыНДС
Процедура ОткрытьФормуПодбораСчетовФактурТребующихОплатыНДС(ПараметрыПодбора, ОповещениеОПодборе) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыПодбора.Организация) Тогда
		ОткрытьФорму("Обработка.ПеречислениеНДСВБюджетПоОтдельнымОперациям.Форма.ПодборНДСКУплате", ПараметрыПодбора,,,,,ОповещениеОПодборе);
	Иначе
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Необходимо выбрать организацию.';
														|en = 'You need to select a company'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()));
	КонецЕсли;
	
КонецПроцедуры

// см. УчетНДСУПКлиент.ОткрытьФормуСостоянияОплатыНДСПоСчетуФактуре
Процедура ОткрытьФормуСостоянияОплатыНДСПоСчетуФактуре(СчетФактура, ФормаВладелец) Экспорт
	
	ПараметрыФормы = Новый Структура("СчетФактура", СчетФактура);
	
	ОбщегоНазначенияУТКлиент.ОткрытьФормуПослеПроверкиПроведенностиДокумента("РегистрСведений.ПодтверждениеОплатыНДСВБюджет.Форма.ФормаДокументыОплаты",
		ПараметрыФормы,
		ФормаВладелец);

КонецПроцедуры

// см. УчетНДСУПКлиент.ОбработкаИзмененияСостоянияОплатыНДСПоСчетуФактуре
Процедура ОбработкаИзмененияСостоянияОплатыНДСПоСчетуФактуре(ИсточникВыбора, ТекстСостояния, КомандаСостояния) Экспорт
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.ПодтверждениеОплатыНДСВБюджет.Форма.ФормаДокументыОплаты" Тогда
		КомандаСостояния.Заголовок = ТекстСостояния;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКоманд

Процедура КорректировочныйСчетФактура(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	РеквизитыДляОбработки = УчетНДСРФВызовСервера.СтруктураРеквизитовДляОбработки(ПараметрКоманды);
	
	ЗначенияЗаполнения = Новый Структура;
	
	Если ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		ТипСчетФактуры = "Выданный";
	ИначеЕсли ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		ТипСчетФактуры = "Полученный";
	ИначеЕсли ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент") Тогда
		ТипСчетФактуры = "ПолученныйНалоговыйАгент";
	КонецЕсли;
	
	Если РеквизитыДляОбработки.Исправление Тогда
		
		ЗначенияЗаполнения.Вставить("Исправление", Истина);
		ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
		Если ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Свойство("ДокументОснование") Тогда
			ЗначенияЗаполнения.Вставить("ДокументОснование", ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.ДокументОснование);
		КонецЕсли;
		Если ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Свойство("РучнаяКорректировкаСуммДокумента") Тогда
			ЗначенияЗаполнения.Вставить("РучнаяКорректировкаСуммДокумента", ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.РучнаяКорректировкаСуммДокумента);
		КонецЕсли;
		Если ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Свойство("СозданНаОсновании") Тогда
			ЗначенияЗаполнения.Вставить("СозданНаОсновании", ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.СозданНаОсновании);
		КонецЕсли;
		ЗначенияЗаполнения.Вставить("ЭтоИсправлениеНаОснованииСФ", Истина);
		
	ИначеЕсли РеквизитыДляОбработки.Свойство("Перевыставленный") И РеквизитыДляОбработки.Перевыставленный = Истина Тогда
		
		Если ТипСчетФактуры="Выданный" Тогда
						
			ТекстСообщения = НСтр("ru = 'Для выбранного документа нельзя ввести корректировочный счет-фактуру.
			|Необходимо воспользоваться рабочим местом ""Перевыставление комитенту(принципалу) счетов-фактур""';
			|en = 'A corrective tax invoice cannot be entered for the selected document.
			|You must use the ""Reissuing invoices to the consignor (principal)"" workplace'");
			
			ВызватьИсключение ТекстСообщения;
			
		КонецЕсли;
		
	Иначе
		
		ЗначенияЗаполнения.Вставить("Исправление", Истина);
		ЗначенияЗаполнения.Вставить("СчетФактураОснование", ПараметрКоманды);
		Если ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Свойство("ДокументОснование") Тогда 
			ЗначенияЗаполнения.Вставить("ДокументОснование", ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.ДокументОснование);
		КонецЕсли;
		Если ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.Свойство("СозданНаОсновании") Тогда
			ЗначенияЗаполнения.Вставить("СозданНаОсновании", ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры.СозданНаОсновании);
		КонецЕсли;
		ЗначенияЗаполнения.Вставить("ЭтоИсправлениеНаОснованииСФ", Истина);
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактура"+ТипСчетФактуры+".ФормаОбъекта",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

Процедура ИсправленныйСчетФактура(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ДокументОснование = МассивСсылок;
	Иначе
		ДокументОснование = МассивСсылок[0];
	КонецЕсли;
	
	ПараметрыРегистрации = УчетНДСРФВызовСервера.ПараметрыРегистрацииСчетовФактурВыданных(ДокументОснование);
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДокументОснование", ДокументОснование);
	ПараметрыОткрытия.Вставить("Организация",       ПараметрыРегистрации.Организация);
	ПараметрыОткрытия.Вставить("Контрагент",        ПараметрыРегистрации.Контрагент);
	ПараметрыОткрытия.Вставить("Исправление",       ПараметрыРегистрации.ИсправлениеОшибок);
	ПараметрыОткрытия.Вставить("Корректировочный",  ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
	ПараметрыОткрытия.Вставить("РеализацияЧерезКомиссионера",
													ПараметрыРегистрации.РеализацияЧерезКомиссионера);

	Если ПараметрыРегистрации.ИсправлениеОшибок Тогда
		
		СчетаФактурыОснования = УчетНДСРФВызовСервера.ЗаполнитьСчетаФактурыОснования(ПараметрыОткрытия);
		Если СчетаФактурыОснования = Неопределено Тогда
			
			ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
			ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполнения.Форма);
			
		Иначе
			
			ТекстВопроса = НСтр("ru = 'По выбранным документам-основаниям необходимо выставить несколько исправленных счетов-фактур.';
								|en = 'Several adjusted tax invoices must be drawn by selected base documents.'") + Символы.ПС 
			+ НСтр("ru = 'Будет создано несколько исправленных счетов-фактур, в которых необходимо вручную заполнить сведения об исправлениях.';
					|en = 'Several corrected tax invoices will be created. Enter the information on corrections manually.'") + Символы.ПС 
			+ НСтр("ru = 'Создать отдельные документы?';
					|en = 'Do you want to create separate documents?'");
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("СчетаФактурыОснования", СчетаФактурыОснования);
			ДополнительныеПараметры.Вставить("ДокументОснование", ДокументОснование);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВвестиОтдельныеСчетаФактурыВыданныеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			
		КонецЕсли;
		
	Иначе
	
		ПараметрыФормы = Новый Структура("Основание, ДокументОснование",ПараметрыОткрытия, ДокументОснование);
		ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполнения.Форма);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ИсправлениеПрочегоНачисленияНДС(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если НЕ ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	
	ОткрытьФорму(
		"Документ.ЗаписьКнигиПродаж.Форма.ФормаДокумента",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

Процедура ТаможеннаяДекларацияЭкспортНаОсновании(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	//++ НЕ УТ
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокумента",
		Новый Структура("Основание", МассивСсылок));
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти