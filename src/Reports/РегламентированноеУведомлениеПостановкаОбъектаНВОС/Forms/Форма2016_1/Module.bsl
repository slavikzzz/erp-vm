
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
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2016_1");
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.ЗаполнитьТаблицуФорматов(ЭтотОбъект, "Форматы2016_1");
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложенияСлужебный.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	ЭтотОбъект["СворачиваемыеЭлементы"] = ПоместитьВоВременноеХранилище(ИдДляСвор);
	Если Не ЭтотОбъект["ДанныеУведомления"].ORG_INFO.Свойство("CALC_TYPE") Тогда
		ЭтотОбъект["ДанныеУведомления"].ORG_INFO.Вставить("CALC_TYPE", "");
		ЭтотОбъект["ДанныеУведомления"].ORG_INFO.Вставить("CALC_TYPE_STR", "");
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

#КонецОбласти

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения об организации";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "ORG_INFO";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "ORG_INFO";
	Стр001.МногострочныеЧасти.Добавить("OKVED");
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Регистрируемый объект";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "EMISS_OBJECT";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "EMISS_OBJECT";
	Стр001.МногострочныеЧасти.Добавить("OKVED");
	Стр001.МногострочныеЧасти.Добавить("OBJCAT_CLASSIF_CRITERIA");
	Стр001.МногострочныеЧасти.Добавить("OBJ_COORDINATES");
	Стр001.МногострочныеЧасти.Добавить("PRODUCTION_VALUE");
	Стр001.МногострочныеЧасти.Добавить("OBJ_TECH_USE");
	Стр001.МногострочныеЧасти.Добавить("OBJ_REDUCE_ACTION");
	Стр001.МногострочныеЧасти.Добавить("OBJ_DISP_MEANS");
	Стр001.МногострочныеЧасти.Добавить("OBJ_MEASURING");
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Объекты размещения"+символы.ПС+"отходов";
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Стр. 1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "WASTE_OBJECT";
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "WASTE_OBJECT";
	Стр001.МногострочныеЧасти.Добавить("OREG_WASTE_FACT");
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Выпуски";
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Стр. 1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "WATER_OBJECT";
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "WATER_OBJECT";
	Стр001.МногострочныеЧасти.Добавить("OREG_WATER_FACT");
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Выбросы ЗВ"+символы.ПС+"в атмосферу";
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Стр. 1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "EMISS_DEP_OBJECT";
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "EMISS_DEP_OBJECT";
	Стр001.МногострочныеЧасти.Добавить("OBJ_TECH_USE");
	Стр001.МногострочныеЧасти.Добавить("OREG_EMISS_FACT");
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
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не ЭтотОбъект["УдалениеСтраницы"] И ЭтотОбъект["ТекущиеМногострочныеЧасти"].Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ЭтотОбъект["ТекущиеМногострочныеЧасти"], ПредУИД);
	КонецЕсли;
	
	ЭтотОбъект["ТекущиеМногострочныеЧасти"] = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	ЭтотОбъект["ТекущийМакет"] = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не ЭтотОбъект["УдалениеСтраницы"] И ЭтотОбъект["ТекущиеМногострочныеЧасти"].Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ЭтотОбъект["ТекущиеМногострочныеЧасти"], ПредУИД);
	КонецЕсли;
	
	ЭтотОбъект["ТекущиеМногострочныеЧасти"] = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	ЭтотОбъект["ТекущийМакет"] = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюМногостраничнуюСтраницу(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = УведомлениеОСпецрежимахНалогообложения.СтруктураПараметровДляСохранения(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СохранитьДанные(ЭтотОбъект, СтруктураПараметров);
	ОбработатьПрисоединенныеФайлы();
КонецПроцедуры

&НаСервере
Процедура ОбработатьПрисоединенныеФайлы()
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.Ссылка КАК Ссылка,
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.ПометкаУдаления КАК ПометкаУдаления,
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.Описание КАК Описание
		|ИЗ
		|	Справочник.УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы КАК УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы
		|ГДЕ
		|	УведомлениеОСпецрежимахНалогообложенияПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
		
		Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если НРег(ВыборкаДетальныеЗаписи.Описание) <> "файл создан автоматически из формы уведомления, редактирование запрещено." Тогда 
				Продолжить;
			КонецЕсли;
			
			КоличествоСтр = ДанныеЛицензий.НайтиСтроки(Новый Структура("ПрисоединенныйФайл", ВыборкаДетальныеЗаписи.Ссылка)).Количество();
			Если КоличествоСтр = 0 И ВыборкаДетальныеЗаписи.ПометкаУдаления = Ложь Тогда 
				ПРФОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				ПРФОбъект.ПометкаУдаления = Истина;
				ПРФОбъект.Записать();
			ИначеЕсли КоличествоСтр > 0 И ВыборкаДетальныеЗаписи.ПометкаУдаления = Истина Тогда
				ПРФОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				ПРФОбъект.ПометкаУдаления = Ложь;
				ПРФОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка при постобработке присоединенных файлов';
				|en = 'Ошибка при постобработке присоединенных файлов'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = УведомлениеОСпецрежимахНалогообложения.ЗагрузкаДанныхУведомления(ЭтотОбъект, СсылкаНаДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрНачинаетсяС(Область.Имя, "AddStr_") Или СтрНачинаетсяС(Область.Имя, "AddStrLabel_") Тогда
		ДобавитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрНачинаетсяС(Область.Имя, "Del_") Тогда
		УдалитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "FINDIVID_BOOL"
		Или Область.Имя = "IS_BOAT_BOOL" 
		Или Область.Имя = "POPUL_LOC_BOOL"
		Или Область.Имя = "MANUFACTURER_BOOL"
		Или Область.Имя = "IMPORTER_BOOL"
		Или Область.Имя = "SEP_DIV_BOOL"
		Или Область.Имя = "POPUL_LOC_BOOL"
		Или Область.Имя = "DRINK_WTS_BOOL" Тогда 
		Область.Значение = Не Область.Значение;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "ЛицензииНаВыбросВАтмосферу" Тогда 
		ОткрытьФормуВводаЛицензий(0);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "ЛицензииНаВыбросВОкружающуюСреду" Тогда 
		ОткрытьФормуВводаЛицензий(1);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "УтверждениеНормативовОтходов" Тогда 
		ОткрытьФормуВводаЛицензий(2);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект["РучнойВвод"] Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина, Истина);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыборКодЗнач(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		ОбработкаАдреса(Область, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	ЭтотОбъект["УдалениеСтраницы"] = Истина;
	УдалитьСтраницуНаСервере();
	ЭтотОбъект["УдалениеСтраницы"] = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАдреса(Область, СтандартнаяОбработка) Экспорт
	РоссийскийАдрес = Неопределено;
	ЗначенияПолей = Неопределено;
	ПредставлениеАдреса = Неопределено;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаАдреса(ЭтотОбъект, Область, РоссийскийАдрес, ЗначенияПолей, ПредставлениеАдреса, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",				"Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", 			ЗначенияПолей);
	ПараметрыФормы.Вставить("Представление", 			ПредставлениеАдреса);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации",	ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
	ДополнительныеПараметры.Вставить("Префикс", ?(СтрНачинаетсяС(Область.Имя, "АДДР"), Лев(Область.Имя, 6), ""));
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтотОбъект;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбновитьАдресВТабличномДокументе(ЭтотОбъект, Результат, Параметры, Истина);
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтроку(ИмяОбласти)
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтроку(ЭтотОбъект, ИмяОбласти);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтроку(ИмяОбласти)
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтроку(ЭтотОбъект, ИмяОбласти);
КонецПроцедуры

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ОбластьИмя) Экспорт 
КонецФункции

&НаКлиенте
Асинх Процедура ПредварительныйПросмотр(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда
		Если Ждать ВопросАсинх("Перед печатью необходимо сохранить изменения. Сохранить изменения?", РежимДиалогаВопрос.ДаНет) 
			<> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
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
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект, "РПН");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект, "РПН");
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "РПН");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "РПН");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "РПН");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "РПН");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "РПН");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru = 'Вы уверены, что уведомление уже сдано?';
													|en = 'Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПроверитьДокумент(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ПроверитьВыгрузкуНаСервере();
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
Процедура ЛицензииНаВыбросВАтмосферу(Команда)
	ОткрытьФормуВводаЛицензий(0);
КонецПроцедуры

&НаКлиенте
Процедура ЛицензииНаВыбросВОкружающуюСреду(Команда)
	ОткрытьФормуВводаЛицензий(1);
КонецПроцедуры

&НаКлиенте
Процедура УтверждениеНормативовОтходов(Команда)
	ОткрытьФормуВводаЛицензий(2);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ОткрытьФормуВводаЛицензий(ФильтрПоТипу)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда
		Если Ждать ВопросАсинх("Перед работой с лицензиями необходимо сохранить документ. Сохранить изменения?", РежимДиалогаВопрос.ДаНет) 
			<> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		СохранитьДанные();
	КонецЕсли;
	
	ПарамСтр = СформироватьПараметрыОткрытияОкнаВводаЛицензий(ФильтрПоТипу);
	ПараметрыДокументов = Новый Структура("Адрес, ФильтрПоТипу, Уведомление", ПарамСтр, ФильтрПоТипу, Объект.Ссылка);
	
	ДополнительныеПараметры = Новый Структура("ФильтрПоТипу", ФильтрПоТипу);
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеЛицензийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Отчет." + Объект.ИмяОтчета + ".Форма.СписокДокументов", ПараметрыДокументов, ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаСервере
Функция СформироватьПараметрыОткрытияОкнаВводаЛицензий(ФильтрПоТипу)
	РезультатСтр = Новый Структура;
	РезультатСтр.Вставить("ДанныеДокументов", ДанныеФормыВЗначение(ДанныеЛицензий, Тип("ТаблицаЗначений")).НайтиСтроки(Новый Структура("Тип", ФильтрПоТипу)));
	
	Возврат ПоместитьВоВременноеХранилище(РезультатСтр, РезультатСтр);
КонецФункции

&НаКлиенте
Процедура РедактированиеЛицензийЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора <> Неопределено Тогда 
		ОбновитьТаблицу(РезультатВыбора, ДополнительныеПараметры.ФильтрПоТипу);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицу(РезультатВыбора, ФильтрПоТипу)
	Результат = ПолучитьИзВременногоХранилища(РезультатВыбора);
	ДанныеЛицензийРезультат = Результат.ДанныеЛицензий;
	НомСтр = ДанныеЛицензий.Количество();
	Пока НомСтр > 0 Цикл 
		НомСтр = НомСтр - 1;
		
		Если ДанныеЛицензий[НомСтр].Тип = ФильтрПоТипу Тогда 
			Строки = ДанныеЛицензийРезультат.НайтиСтроки(Новый Структура("УИД", ДанныеЛицензий[НомСтр].УИД));
			Если Строки.Количество() = 0 Тогда 
				ДанныеЛицензий.Удалить(НомСтр);
			Иначе
				ЗаполнитьЗначенияСвойств(ДанныеЛицензий[НомСтр], Строки[0]);
				ДанныеЛицензийРезультат.Удалить(Строки[0]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из ДанныеЛицензийРезультат Цикл
		НовСтр = ДанныеЛицензий.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		НовСтр.Тип = ФильтрПоТипу;
	КонецЦикла;
	
	УдалитьИзВременногоХранилища(РезультатВыбора);
	Модифицированность = Истина;
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
