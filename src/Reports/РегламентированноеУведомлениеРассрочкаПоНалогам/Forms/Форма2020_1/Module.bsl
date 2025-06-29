#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиПоНалоговымПлатежам;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложенияСлужебный.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	ЭтотОбъект["СворачиваемыеЭлементы"] = ПоместитьВоВременноеХранилище(ИдДляСвор);
	СформироватьСписокНалогов();
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.НаименованиеЭтапа.Заголовок = "В работе";
	Иначе
		Статус = РегламентированнаяОтчетность.СохраненныйСтатусОтправкиУведомления(Объект.Ссылка);
		Если Статус <> Неопределено Тогда
			Элементы.НаименованиеЭтапа.Заголовок
			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																			|en = '%1'"), Статус);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СформироватьСписокНалогов()
	Мкт = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("СписокНалоговКБКСроков");
	ВсеНалоги = Новый Соответствие;
	Для Инд = 1 По Мкт.ВысотаТаблицы Цикл
		Налог = Мкт.Область(Инд, 1, Инд, 1).Текст;
		Если ЗначениеЗаполнено(Мкт.Область(Инд, 2, Инд, 2).Текст) Тогда 
			НовСтр = Налоги.Добавить();
			НовСтр.Налог = Налог;
			НовСтр.КБК = Мкт.Область(Инд, 2, Инд, 2).Текст;
			НовСтр.КБКОписание = Мкт.Область(Инд, 3, Инд, 3).Текст;
		КонецЕсли;
		Если ЗначениеЗаполнено(Мкт.Область(Инд, 4, Инд, 4).Текст) Тогда 
			НовСтр = СрокиУплаты.Добавить();
			НовСтр.Налог = Налог;
			НовСтр.Срок = Дата(Сред(Мкт.Область(Инд, 4, Инд, 4).Текст, 7, 4) + Сред(Мкт.Область(Инд, 4, Инд, 4).Текст, 4, 2) + Сред(Мкт.Область(Инд, 4, Инд, 4).Текст, 1, 2));
			НовСтр.СрокОписание = Мкт.Область(Инд, 4, Инд, 4).Текст;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Налог) И ВсеНалоги[Налог] = Неопределено Тогда 
			НовСтр = СписокНалогов.Добавить();
			НовСтр.Код = Налог;
			НовСтр.Название = Налог;
			ВсеНалоги[Налог] = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	ЗаполнитьНачальныеДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ЭтотОбъект["ДанныеУведомления"]["Титульная"];
	ДанныеУведомленияОбязательство = ЭтотОбъект["ДанныеУведомления"]["Обязательство"];
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	ДанныеУведомленияОбязательство.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	
	Оп1 = "";
	Оп2 = "";
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ПолныйАдрЮР";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		Оп1 = СведенияОбОрганизации.ИННЮЛ + "/" + СведенияОбОрганизации.КППЮЛ + ", " + СведенияОбОрганизации.НаимЮЛПол;
		Оп2 = СведенияОбОрганизации.ПолныйАдрЮР;
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,АдрМЖ";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.ФИО);
		Оп1 = СведенияОбОрганизации.ИННФЛ + ", " + СведенияОбОрганизации.ФИО;
		Оп2 = СведенияОбОрганизации.АдрМЖ;
	КонецЕсли;
	
	ДанныеУведомленияТитульный.Вставить("Наим1", Оп1);
	ДанныеУведомленияТитульный.Вставить("Наим2", Оп2);
	ДанныеУведомленияОбязательство.Вставить("Наим1", Оп1);
	ДанныеУведомленияОбязательство.Вставить("Наим2", Оп2);
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Заявление";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Сведения о сроках";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "<Налог не указан>";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "НалогКБК";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	СтрРег.МногострочныеЧасти.Добавить("МнгСтр");
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "НалогКБК";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Обязательство";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Обязательство";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Обязательство";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.НеобходимоФормированиеТабличногоДокумента(ЭтотОбъект, Элемент, ЭтотОбъект["УИДПереключение"]) Тогда
		ОтключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение");
		ПодключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтрокиЗавершение() Экспорт 
	ПредУИД = ЭтотОбъект["УИДПереключение"];
	Элемент = Элементы.ДеревоСтраниц;
	
	Если Элемент.ТекущиеДанные.Многостраничность Тогда 
		ИмяМакета = УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
		ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьМногострочныеЧасти(Элемент.ТекущиеДанные), ПредУИД);
	Иначе 
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, Элемент.ТекущиеДанные.МногострочныеЧасти, ПредУИД);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не ЭтотОбъект["УдалениеСтраницы"] И ЭтотОбъект["ТекущиеМногострочныеЧасти"].Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ЭтотОбъект["ТекущиеМногострочныеЧасти"], ПредУИД);
	КонецЕсли;
	
	ЭтотОбъект["ТекущиеМногострочныеЧасти"] = ОбщегоНазначенияКлиентСервер.СкопироватьСписокЗначений(МногострочныеЧасти);
	ЭтотОбъект["ТекущийМакет"] = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюМногостраничнуюСтраницу(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
	Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Область(1, 1, 1, 1);
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не ЭтотОбъект["УдалениеСтраницы"] И ЭтотОбъект["ТекущиеМногострочныеЧасти"].Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ЭтотОбъект["ТекущиеМногострочныеЧасти"], ПредУИД);
	КонецЕсли;
	
	ЭтотОбъект["ТекущиеМногострочныеЧасти"] = ОбщегоНазначенияКлиентСервер.СкопироватьСписокЗначений(МногострочныеЧасти);
	ЭтотОбъект["ТекущийМакет"] = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	Если Область.Имя = "Налог" Тогда 
		ПроставитьИменаСтраниц(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = УведомлениеОСпецрежимахНалогообложения.СтруктураПараметровДляСохранения(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СохранитьДанные(ЭтотОбъект, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	УведомлениеОСпецрежимахНалогообложения.ЗагрузкаДанныхУведомления(ЭтотОбъект, СсылкаНаДанные);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда) Экспорт 
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	ПроставитьИменаСтраниц(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	ЭтотОбъект["УдалениеСтраницы"] = Истина;
	УдалитьСтраницуНаСервере();
	ЭтотОбъект["УдалениеСтраницы"] = Ложь;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПреобразоватьДлиннуюСтроку(Знач Налог)
	Если СтрДлина(Налог) > 40 Тогда
		Налог = Лев(Налог, СтрНайти(Налог, " ", НаправлениеПоиска.СНачала, 40)) + "...";
	КонецЕсли;
	Если СтрДлина(Налог) > 22 Тогда
		Инд = СтрНайти(Налог, " ", НаправлениеПоиска.СНачала, 20);
		Налог = Лев(Налог, Инд - 1) + Символы.ПС + Сред(Налог, Инд + 1);
	КонецЕсли;
	Возврат Налог;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПроставитьИменаСтраниц(Форма)
	ДопСтраницы = Форма.ДеревоСтраниц.ПолучитьЭлементы()[1].ПолучитьЭлементы();
	Для Инд = 0 По ДопСтраницы.Количество() - 1 Цикл 
		Налог = Форма.ДанныеМногостраничныхРазделов.НалогКБК[Инд].Значение.Налог;
		Если ЗначениеЗаполнено(Налог) Тогда
			ДопСтраницы[Инд].Наименование = ПреобразоватьДлиннуюСтроку(Налог);
		Иначе
			ДопСтраницы[Инд].Наименование = "<Налог не указан>";
		КонецЕсли;
	КонецЦикла;
	ТекущаяСтрока = Форма.Элементы.ДеревоСтраниц.ТекущаяСтрока;
	Форма.Элементы.ДеревоСтраниц.ТекущаяСтрока = Форма.ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
	Форма.Элементы.ДеревоСтраниц.ТекущаяСтрока = ТекущаяСтрока;
	Форма.Элементы.ДеревоСтраниц.Обновить();
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	ПроставитьИменаСтраниц(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтроку(ИмяОбласти)
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтроку(ЭтотОбъект, ИмяОбласти);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтроку(ИмяОбласти)
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтроку(ЭтотОбъект, ИмяОбласти);
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
				ЭтотОбъект, ЭтотОбъект["ТекущиеМногострочныеЧасти"], ЭтотОбъект["УИДТекущаяСтраница"]);
	УведомлениеОСпецрежимахНалогообложения.КопироватьСтраницуУведомления(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтраницуНаКлиенте() Экспорт 
	СкопироватьСтраницуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуНаКлиенте(ИмяОбласти) Экспорт 
	ДобавитьСтроку(ИмяОбласти);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокуНаКлиенте(ИмяОбласти) Экспорт 
	УдалитьСтроку(ИмяОбласти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрНачинаетсяС(Область.Имя, "ПризнакГалка") Тогда
		Область.Значение = Не Область.Значение;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "ПерейтиКНалогам" Тогда
		Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[1].ПолучитьЭлементы()[0].ПолучитьИдентификатор();
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли УведомлениеОСпецрежимахНалогообложенияКлиент.ТиповойВыбор(ЭтотОбъект, Область, СтандартнаяОбработка) Или ЭтотОбъект["РучнойВвод"] Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "Налог" Тогда 
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок",          "Выбор налога");
		ПараметрыФормы.Вставить("ОтключитьВидимостьКолонкиКод", Истина);
		ПараметрыФормы.Вставить("ТаблицаЗначений",    СписокНалогов);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Область.Значение));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборНалогаЗавершение", ЭтотОбъект, Новый Структура("Область", Область));
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Область.Имя = "КБК" Тогда
		ЭтотОбъект["ЗагружаемыеКоды"].Очистить();
		Налог = ПредставлениеУведомления.Области.Найти("Налог").Значение;
		Для Каждого Стр Из Налоги.НайтиСтроки(Новый Структура("Налог", Налог)) Цикл 
			НовСтр = ЭтотОбъект["ЗагружаемыеКоды"].Добавить();
			НовСтр.Код = Стр.КБК;
			НовСтр.Название = Стр.КБКОписание;
		КонецЦикла;
		
		Если ЭтотОбъект["ЗагружаемыеКоды"].Количество() > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Заголовок",          "Выбор КБК");
			ПараметрыФормы.Вставить("ТаблицаЗначений",    ЭтотОбъект["ЗагружаемыеКоды"]);
			ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Область.Значение));
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ВыборНалогаЗавершение", ЭтотОбъект, Новый Структура("Область, ОбластьОписание", Область, ПредставлениеУведомления.Области.Найти("КБКОписание")));
			ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	ИначеЕсли СтрНачинаетсяС(Область.Имя, "СрокУплаты") Тогда
		ЭтотОбъект["ЗагружаемыеКоды"].Очистить();
		Налог = ПредставлениеУведомления.Области.Найти("Налог").Значение;
		Для Каждого Стр Из СрокиУплаты.НайтиСтроки(Новый Структура("Налог", Налог)) Цикл 
			НовСтр = ЭтотОбъект["ЗагружаемыеКоды"].Добавить();
			НовСтр.Код = Формат(Стр.Срок, "ДФ=yyyy-MM-dd");
			НовСтр.Название = Стр.СрокОписание;
		КонецЦикла;
		
		Если ЭтотОбъект["ЗагружаемыеКоды"].Количество() > 0 Тогда 
			СтандартнаяОбработка = Ложь;
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Заголовок",          "Номативные сроки уплаты");
			ПараметрыФормы.Вставить("ТаблицаЗначений",    ЭтотОбъект["ЗагружаемыеКоды"]);
			ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ""));
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ВыборНалогаЗавершение", ЭтотОбъект, Новый Структура("Область, ДатаКод", Область, Истина));
			ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборНалогаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ПрошлоеЗначение = ДополнительныеПараметры.Область.Значение;
		Если ДополнительныеПараметры.Свойство("ДатаКод") Тогда
			ДополнительныеПараметры.Область.Значение = ЭтотОбъект["ОТД"].ПривестиЗначение(СтрЗаменить(Результат.Код, "-", ""));
			УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ДополнительныеПараметры.Область, Истина);
		Иначе 
			ДополнительныеПараметры.Область.Значение = Результат.Код;
			УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ДополнительныеПараметры.Область, Истина);
		КонецЕсли;
		
		Если ДополнительныеПараметры.Свойство("ОбластьОписание") Тогда 
			ДополнительныеПараметры.ОбластьОписание.Значение = Результат.Название;
			УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ДополнительныеПараметры.ОбластьОписание, Истина);
		КонецЕсли;
		
		Если ДополнительныеПараметры.Область.Имя = "Налог" Тогда 
			Если ЗначениеЗаполнено(ДополнительныеПараметры.Область.Значение) Тогда 
				Элементы.ДеревоСтраниц.ТекущиеДанные.Наименование = ПреобразоватьДлиннуюСтроку(ДополнительныеПараметры.Область.Значение);
			Иначе
				Элементы.ДеревоСтраниц.ТекущиеДанные.Наименование = "<Налог не указан>";
			КонецЕсли;
			
			Если Не (ПрошлоеЗначение = ДополнительныеПараметры.Область.Значение) Тогда 
				ОблКБК = ПредставлениеУведомления.Области["КБК"];
				ОблКБК.Значение = Неопределено;
				УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ОблКБК, Истина);
				ОчиститьДополнительныеСтрокиСтраницы();
			КонецЕсли;
			
			ТекущаяСтрока = Элементы.ДеревоСтраниц.ТекущаяСтрока;
			Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
			Элементы.ДеревоСтраниц.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОчиститьДополнительныеСтрокиСтраницы()
	КоличествоДополнительныхСтрок = ЭтотОбъект["ДанныеДопСтрокСтраницы"].МнгСтр.Количество();
	Верх = ПредставлениеУведомления.Области["Del_МнгСтр___1"].Низ + 1;
	Низ = ПредставлениеУведомления.Области["Del_МнгСтр___" + КоличествоДополнительныхСтрок].Низ + 1;
	ПредставлениеУведомления.УдалитьОбласть(ПредставлениеУведомления.Область(Верх, , Низ), ТипСмещенияТабличногоДокумента.ПоВертикали);
	Пока ЭтотОбъект["ДанныеДопСтрокСтраницы"].МнгСтр.Количество() > 1 Цикл 
		ЭтотОбъект["ДанныеДопСтрокСтраницы"].МнгСтр.Удалить(0);
	КонецЦикла;
	ПерваяСтрока = ЭтотОбъект["ДанныеДопСтрокСтраницы"].МнгСтр[0].Значение;
	Для Каждого КЗ Из ПерваяСтрока Цикл 
		ОблМнг = ПредставлениеУведомления.Области[КЗ.Ключ + ЭтотОбъект["РазделительНомераСтроки"] + "1"];
		ОблМнг.Значение = Неопределено;
	КонецЦикла;
	ПоказатьТекущуюМногостраничнуюСтраницу("НалогКБК", ЭтотОбъект["ТекущиеМногострочныеЧасти"], ЭтотОбъект["УИДТекущаяСтраница"]);
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеСтатусаНажатие(Элемент)
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПустаяСсылка"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru = 'Вы уверены, что уведомление уже сдано?';
													|en = 'Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(
		ЭтотОбъект, "Открыть", Ложь, ЭтотОбъект["СтруктураРеквизитовУведомления"].СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаРучнойВвод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры
