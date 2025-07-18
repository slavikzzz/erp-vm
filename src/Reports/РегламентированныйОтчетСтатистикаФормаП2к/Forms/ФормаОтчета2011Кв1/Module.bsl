&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// Обход ошибки платформы Параметр сеанса отсутствует или удален
	ПолеТабличногоДокументаФормаОтчета.Очистить();
	
	СформироватьСтруктуруРеквизитовФормы();

	СтруктураРеквизитовФормы.СписокПечатаемыхЛистов = Новый СписокЗначений;
	
   	// Версия формы
	СтруктураРеквизитовФормы.мВерсияФормы = "17/12/2008"; 
	// Код отчета, равен коду по ОКУД
	СтруктураРеквизитовФормы.мКодОтчета   = "0617005";
	
	СтруктураРеквизитовФормы.мПечатныеФормы = Новый СписокЗначений;
	
	ПолеТабличногоДокументаФормаОтчета.Вывести(Отчеты[Сред(Лев(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") - 1), 7)].ПолучитьМакет("ФормаОтчета2011Кв1_ФормаОтчета"));
	
	СтруктураРеквизитовФормы.мВыбраннаяФорма          = Параметры.мВыбраннаяФорма;
	СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	СтруктураРеквизитовФормы.мСкопированаФорма        = Параметры.мСкопированаФорма;
	СтруктураРеквизитовФормы.мСохраненныйДок          = Параметры.мСохраненныйДок;
	СтруктураРеквизитовФормы.Организация        	  = Параметры.Организация;
	
	ДатаПодписи	= ТекущаяДатаСеанса();
	
	СтруктураРеквизитовФормы.СправочникиВидыКонтактнойИнформацииПочтовыйАдресОрганизации = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации;
	
	Инициализация(Параметры.БезОткрытияФормы);
		
КонецПроцедуры

&НаСервере
Процедура СформироватьСтруктуруРеквизитовФормы()
	
	СтруктураРеквизитовФормы = РегламентированнаяОтчетность.СформироватьСтруктуруОбязательныхРеквизитовСтатистическогоОтчета();
	
КонецПроцедуры

&НаСервере
Процедура Инициализация(БезОткрытияФормы = Ложь) Экспорт
	
	ФормироватьСтруктуруСвойствСтраниц();

	СтруктураРеквизитовФормы.мБезОткрытияФормы = БезОткрытияФормы;
	
	СтруктураРеквизитовФормы.мВПрограммеИзмененаОрганизация = Ложь;

	ТекТабличноеПоле = ПолеТабличногоДокументаФормаОтчета;

	СтруктураРеквизитовФормы.ВидДокумента = 0;
	НомерКорректировки = 1;
	СтруктураРеквизитовФормы.мАдресвФорматеДляВыгрузки = "";

	Если СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда

		Если СтруктураРеквизитовФормы.мСкопированаФорма <> Неопределено Тогда
			// документ скопирован
			ВосстановитьСохраненныеДанные();
		КонецЕсли;
		
		Модифицированность = Истина;

	Иначе

		// При открытии или при копировании сохраненного
		// отчета восстанавливаем сохраненные данные.
		ВосстановитьСохраненныеДанные();
		
		Если ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСкопированаФорма) Тогда
			СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено;
		КонецЕсли;
		
		Если НЕ БезОткрытияФормы
           И НЕ СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда
				   
        	ЗаблокироватьДанныеДляРедактирования(СтруктураРеквизитовФормы.мСохраненныйДок, , ЭтаФорма.УникальныйИдентификатор);

        КонецЕсли;

	КонецЕсли;

	Если СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда
		НомерКорректировки = 0;
	Иначе
		НомерКорректировки = СтруктураРеквизитовФормы.мСохраненныйДок.Вид;
	КонецЕсли;
	
	ПолеТабличногоДокументаФормаОтчета.Области.НомерКорректировки.Значение = НомерКорректировки;
	ПолеТабличногоДокументаФормаОтчета.Области.ДатаСоставленияОтчета.Значение = ДатаПодписи;

	ПоказатьПериод();

	Если СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Или СтруктураРеквизитовФормы.мВПрограммеИзмененаОрганизация Тогда
		ЗаполнитьСведенияОбОрганизацииНаСервере();
	КонецЕсли;
	
	СтруктураРеквизитовФормы.НаимОрганизации = СтруктураРеквизитовФормы.Организация.Наименование;
	
	ТекущийЭлемент = Элементы["ПолеТабличногоДокументаФормаОтчета"];
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	// ПроцессыОбработкиДокументов
	//
	РегламентированнаяОтчетность.ПриИнициализации(ЭтотОбъект,
		?(ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок),
			СтруктураРеквизитовФормы.мСохраненныйДок,
			СтруктураРеквизитовФормы.ПустаяСсылкаНаРегламентированныйОтчет));
	//
	// ПроцессыОбработкиДокументов
	
КонецПроцедуры

// Блок обязательных процедур
// Формирует дерево значений - структуру страниц отчета,
// содержащей настройки показа страниц, вывода на печать и выгрузки в ИФНС.
//
&НаСервере
Процедура ФормироватьСтруктуруСвойствСтраниц() Экспорт

	мСвойстваРазделовДекларации.ПолучитьЭлементы().Очистить();

	СтрокаУровня1 = мСвойстваРазделовДекларации.ПолучитьЭлементы().Добавить();
	
	// Добавим св-ва Титульного листа
	СтрокаУровня1.ИмяСтраницы                          = "ФормаОтчета";
	СтрокаУровня1.МногострочностьВРазделе              = 0;
	СтрокаУровня1.СохранятьМногострКакТЗ               = Неопределено;
	СтрокаУровня1.МногостраничностьВРазделе            = Ложь;
	СтрокаУровня1.ОчищатьРаздел                        = Ложь;
	СтрокаУровня1.ИмяПредставления                     = "";
	СтрокаУровня1.ПредставлениеДанных                  = Ложь;
	СтрокаУровня1.РазделОбязателенДляВыгрузки          = Неопределено;
	СтрокаУровня1.НазваниеПанелиТабличногоПоляРаздела  = "ОсновнаяПанель";
	СтрокаУровня1.РазделЯвляетсяАвтозаполняемым        = Ложь;	

КонецПроцедуры // ФормироватьСтруктуруСтраницОтчета()

// Восстанавливает сохраненные данные отчета.
//
&НаСервере
Процедура ВосстановитьСохраненныеДанные()
	
	Перем ДанныеМногострочныхРазделов;
	Перем ДанныеВариановАвтоЗаполнения;
	Перем ПоказателиОтчета;
	Перем ВерсияФормы;

	// В случае, если формы была скопирована по F9, то проверим, не изменилась ли организация.
	Если СтруктураРеквизитовФормы.Организация <> СтруктураРеквизитовФормы.мСохраненныйДок.Организация
	   И СтруктураРеквизитовФормы.Организация <> РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа("СправочникСсылка.Организации")
	   И СтруктураРеквизитовФормы.Организация <> Неопределено Тогда
		// Меняем переменную, для того, чтобы запустилась процедура ЗаполнитьСведенияОбОрганизации
		СтруктураРеквизитовФормы.мВПрограммеИзмененаОрганизация = Истина;
	Иначе
		// восстанавливаем реквизиты отчета
		СтруктураРеквизитовФормы.Организация = СтруктураРеквизитовФормы.мСохраненныйДок.Организация;
	КонецЕсли;

	ДатаПодписи          						      = СтруктураРеквизитовФормы.мСохраненныйДок.ДатаПодписи;
	СтруктураРеквизитовФормы.ЕдиницаИзмерения         = СтруктураРеквизитовФормы.мСохраненныйДок.ЕдиницаИзмерения;
	СтруктураРеквизитовФормы.ТочностьЕдиницыИзмерения = СтруктураРеквизитовФормы.мСохраненныйДок.ТочностьЕдиницыИзмерения;
	Комментарий           					          = СтруктураРеквизитовФормы.мСохраненныйДок.Комментарий;

	// восстанавливаем сохраненные данные отчета
	СписокСохранения = СтруктураРеквизитовФормы.мСохраненныйДок.ДанныеОтчета.Получить();
    	
	// восстанавливаем сохраненные данные вариантов автозаполнения ячеек
	Если СписокСохранения.Свойство("ДанныеВариантовАвтоЗаполнения", ДанныеВариановАвтоЗаполнения) Тогда
		
		Если НЕ ДанныеВариановАвтоЗаполнения = Неопределено Тогда
			
			мСтруктураВариантыЗаполнения.Очистить();
			
			Для Каждого ЭлементСтруктуры Из ДанныеВариановАвтоЗаполнения Цикл
				
				мСтруктураВариантыЗаполнения.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Ключ);
				
				ЭтаФорма["ТаблицаВариантыЗаполнения" + ЭлементСтруктуры.Ключ].Очистить();
				
				Для Каждого ЭлементМассива Из ЭлементСтруктуры.Значение Цикл
										
					ТаблВарЗаполнения = ЭтаФорма["ТаблицаВариантыЗаполнения" + ЭлементСтруктуры.Ключ].Добавить().ТаблицаВариантовЗаполнения;
										
					ЗначениеВДанныеФормы(ЭлементМассива, ТаблВарЗаполнения);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
				 		
	КонецЕсли;

	// восстанавливаем версию формы
	СписокСохранения.Свойство("ВерсияФормы", ВерсияФормы);

	// восстановим сохраненные данные редактируемых ячеек
	СписокСохранения.Свойство( "ПоказателиОтчета", ПоказателиОтчета );

	Для Каждого ПоказателиСтраницы Из ПоказателиОтчета Цикл
		ИмяТекТабличноеПоле = ПоказателиСтраницы.Ключ;
		ТекТабличноеПоле    = ЭтаФорма[ИмяТекТабличноеПоле];
		ПоказателиТаблПоле  = ПоказателиСтраницы.Значение;

		Для Каждого Показатель Из ПоказателиТаблПоле Цикл
			ИмяПоказателя       = Показатель.Ключ;
			ЗначениеПоказателя  = Показатель.Значение;

			// установим значение в таблице
			Попытка
				ТекТабличноеПоле.Области[ИмяПоказателя].Значение = ЗначениеПоказателя;
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЦикла;

	СтруктураРеквизитовФормы.мАдресвФорматеДляВыгрузки = ПолеТабличногоДокументаФормаОтчета.Области.ОргАдрес.Значение;
	ПолеТабличногоДокументаФормаОтчета.Области.ОргАдрес.Значение = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых(СтруктураРеквизитовФормы.мАдресвФорматеДляВыгрузки);

	РегламентированнаяОтчетность.ОперацииПриВосстановленииРегламентированногоОтчета(ЭтаФорма);

	Модифицированность   = Ложь;
	
КонецПроцедуры // ВосстановитьСохраненныеДанные()

&НаСервере
Процедура ЗаполнитьСведенияОбОрганизацииНаСервере(ВПрограммеИзмененаДатаПодписи = Ложь)
	
	РегламентированнаяОтчетностьКлиентСервер.ЗаполнитьСведенияОбОрганизацииДляОтчетаСтатистики(ЭтаФорма, ВПрограммеИзмененаДатаПодписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведенияОбОрганизацииНаКлиенте(ВПрограммеИзмененаДатаПодписи = Ложь)
	
	РегламентированнаяОтчетностьКлиентСервер.ЗаполнитьСведенияОбОрганизацииДляОтчетаСтатистики(ЭтаФорма, ВПрограммеИзмененаДатаПодписи);
	
КонецПроцедуры

// Процедура управляет показом в форме периода построения отчета,
//
&НаСервере
Процедура ПоказатьПериод()

	// Период для показа в шапке отчета   	
	СтруктураРеквизитовФормы.СтрПериодОтчета = ПредставлениеПериода(НачалоДня(СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета), КонецДня(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета), "ФП = Истина");	
	
	// Период в заголовке отчета
	ПериодОтчета = " за " + СтруктураРеквизитовФормы.СтрПериодОтчета;
	ПолеТабличногоДокументаФормаОтчета.Области.ПериодОтчета.Значение = ПериодОтчета;

КонецПроцедуры // ПоказатьПериод()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СтрНайти(Заголовок, СтруктураРеквизитовФормы.СтрПериодОтчета) = 0 Тогда
		Заголовок = Заголовок + " за " + СтруктураРеквизитовФормы.СтрПериодОтчета;
	КонецЕсли;
	
	ОргСтр = " (" + СтруктураРеквизитовФормы.НаимОрганизации + ")";
	Если СтрНайти(Заголовок, ОргСтр) = 0 Тогда
		Заголовок = Заголовок + ОргСтр;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ВыполнитьПроверкуПередОткрытием", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуПередОткрытием()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	Отказ = Ложь;
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПередОткрытиемФормыРегламентированногоОтчета(ОписаниеОповещения, ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Модифицированность = Ложь;
		Закрыть();
		Возврат;
	КонецЕсли;

КонецПроцедуры
 
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
			
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
				
		Возврат;
		
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
		
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
    
	РегламентированнаяОтчетность.ПриЗакрытииРегламентированногоОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьОтчет(Команда)
	
	СохранитьНаКлиенте();
	
КонецПроцедуры // СохранитьОтчет()

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь, ВыполняемоеОповещение = Неопределено) Экспорт
	
	Вариант = СтруктураРеквизитовФормы.ВидДокумента * НомерКорректировки;
	
	Если НЕ РегламентированнаяОтчетностьКлиент.ПриЗаписиРегламентированногоОтчетаНаКлиенте(ЭтаФорма, , Автосохранение, Вариант) Тогда
		Возврат;
	КонецЕсли;
	
	ПодобныйОтчетСуществует = Ложь;
	ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки = Ложь;
	
	// формируем данные редактируемых ячеек таблицы
	ПоказателиОтчета = Новый Структура();
	
	#Если ВебКлиент Тогда
		ЗаполнитьПоказателиОтчетаНаСервере(ПоказателиОтчета);
	#Иначе
		ЗаполнитьПоказателиОтчетаНаКлиенте(ПоказателиОтчета);
	#КонецЕсли
	
	РезультатСохранения = ПередСохранением(, ПодобныйОтчетСуществует, Вариант, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, Автосохранение, ПоказателиОтчета);
	
	ВидДокументаНомерКорректировкиИзменен = Неопределено;
	
	Если ПодобныйОтчетСуществует И Автосохранение Тогда
		Возврат;
	КонецЕсли;
	
	НуженВопросПередСохранением = (ПодобныйОтчетСуществует ИЛИ ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки);
	
	Если НуженВопросПередСохранением Тогда
		СохранитьНаКлиентеСВопросом(Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПодобныйОтчетСуществует, ПоказателиОтчета);
	Иначе		
		ПослеСохраненияНаКлиенте(ВыполняемоеОповещение, РезультатСохранения);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиентеСВопросом(Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПодобныйОтчетСуществует, ПоказателиОтчета)
	
	Если ПодобныйОтчетСуществует Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, "Сохранить");
		Кнопки.Добавить(КодВозвратаДиалога.Нет, "Отмена");
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отчет с видом %1 уже существует.
		|Сохранить отчет с таким же видом?';
		|en = 'Отчет с видом %1 уже существует.
		|Сохранить отчет с таким же видом?'"), ?(Вариант = 0, """Первичный""", """Корректирующий/" + Вариант + """"));
		ДополнительныеПараметры = Новый Структура("Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПоказателиОтчета", Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПоказателиОтчета);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросСохранитьОтчетСТакимЖеВидомЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , Кнопки.Получить(1).Значение);
		
	Иначе
		
		СохранитьНаКлиентеСВопросомПродолжение(Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПоказателиОтчета);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохранитьОтчетСТакимЖеВидомЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Автосохранение = ДополнительныеПараметры.Автосохранение;
	Вариант = ДополнительныеПараметры.Вариант;
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки = ДополнительныеПараметры.ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки;
	ПоказателиОтчета = ДополнительныеПараметры.ПоказателиОтчета;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СохранитьНаКлиентеСВопросомПродолжение(Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПоказателиОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиентеСВопросомПродолжение(Автосохранение, Вариант, ВыполняемоеОповещение, ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки, ПоказателиОтчета)
	
	Если ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ВидОтчета", Вариант);
		
		ФормаВопроса = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ВопросПриИзмененииВидаДокументаНомераКорректировки", ПараметрыФормы);
		
		ДополнительныеПараметры = Новый Структура("Автосохранение, Вариант, ВыполняемоеОповещение, ПоказателиОтчета", Автосохранение, Вариант, ВыполняемоеОповещение, ПоказателиОтчета);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПриИзмененииВидаДокументаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ФормаВопроса.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
		ФормаВопроса.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ФормаВопроса.Открыть();
		
	Иначе
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сохраняется %1...';
																				|en = 'Сохраняется %1...'"), ЭтаФорма.Заголовок), , , БиблиотекаКартинок.Записать);
		РезультатСохранения = Сохранить(Автосохранение, , Вариант, Ложь, ПоказателиОтчета);
		ПослеСохраненияНаКлиенте(ВыполняемоеОповещение, РезультатСохранения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииВидаДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Автосохранение = ДополнительныеПараметры.Автосохранение;
	Вариант = ДополнительныеПараметры.Вариант;
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	ПоказателиОтчета = ДополнительныеПараметры.ПоказателиОтчета;
	
	
	КодВозврата = Результат;
	
	Если КодВозврата = КодВозвратаДиалога.Да
		ИЛИ КодВозврата = КодВозвратаДиалога.Нет Тогда
		
		ВидДокументаНомерКорректировкиИзменен = ?(КодВозврата = КодВозвратаДиалога.Да, Истина, Ложь);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сохраняется %1...';
																			|en = 'Сохраняется %1...'"), ЭтаФорма.Заголовок), , , БиблиотекаКартинок.Записать);
	РезультатСохранения = Сохранить(Автосохранение, , Вариант, ВидДокументаНомерКорректировкиИзменен, ПоказателиОтчета);
	ПослеСохраненияНаКлиенте(ВыполняемоеОповещение, РезультатСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияНаКлиенте(ВыполняемоеОповещение, РезультатСохранения)
	
	КлючУникальности = СтруктураРеквизитовФормы.мСохраненныйДок;
	
	Если РезультатСохранения Тогда
		
		РегламентированнаяОтчетностьКлиент.ПослеЗаписиРегламентированногоОтчета(ЭтаФорма);
		
		Если ВыполняемоеОповещение <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
// СохранитьНаКлиенте

&НаСервере
Процедура ЗаполнитьПоказателиОтчетаНаСервере(ПоказателиОтчета)
	
	РегламентированнаяОтчетностьКлиентСервер.ЗаполнитьПоказателиОтчета(ЭтаФорма, ПоказателиОтчета);
	           	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказателиОтчетаНаКлиенте(ПоказателиОтчета)
	
	РегламентированнаяОтчетностьКлиентСервер.ЗаполнитьПоказателиОтчета(ЭтаФорма, ПоказателиОтчета);
	
КонецПроцедуры

&НаСервере
Функция Сохранить(Автосохранение = Ложь, КодИФНС = "не применимо", Вариант = Неопределено, ВидДокументаНомерКорректировкиИзменен = Неопределено, ПоказателиОтчета = Неопределено) Экспорт
	
	ДанныеДляРазблокирования = Неопределено;
	
	Если НЕ СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда
		Если НЕ СтруктураРеквизитовФормы.мБезОткрытияФормы Тогда
			ДанныеДляРазблокирования = Новый Структура("Ключ,ИдФормы",
			СтруктураРеквизитовФормы.мСохраненныйДок, ЭтаФорма.УникальныйИдентификатор);
		КонецЕсли;
		СтруктураРеквизитовФормы.мСохраненныйДок = СтруктураРеквизитовФормы.мСохраненныйДок.ПолучитьОбъект();
	КонецЕсли;
	
	Если НЕ РегламентированнаяОтчетность.ПриЗаписиРегламентированногоОтчетаНаСервере(ЭтаФорма, КодИФНС, Автосохранение, Вариант, ВидДокументаНомерКорректировкиИзменен, СтруктураРеквизитовФормы.мСохраненныйДок) Тогда
		СтруктураРеквизитовФормы.мСохраненныйДок = СтруктураРеквизитовФормы.мСохраненныйДок.Ссылка;
		Возврат Ложь;
	КонецЕсли;

	СтруктураРеквизитовФормы.мСохраненныйДок.ФорматВыгрузки = "Автоматически";// установим текущие значения реквизитов документа
	СтруктураРеквизитовФормы.мСохраненныйДок.ИсточникОтчета           = Метаданные.Отчеты[Сред(Лев(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") - 1), 7)].Имя;
	СтруктураРеквизитовФормы.мСохраненныйДок.НаименованиеОтчета       = Метаданные.Отчеты[Сред(Лев(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") - 1), 7)].ОсновнаяФорма.Синоним;
	СтруктураРеквизитовФормы.мСохраненныйДок.ДатаНачала               = СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета;
	СтруктураРеквизитовФормы.мСохраненныйДок.ДатаОкончания            = СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета;
	СтруктураРеквизитовФормы.мСохраненныйДок.ВыбраннаяФорма           = СтруктураРеквизитовФормы.мВыбраннаяФорма;
	СтруктураРеквизитовФормы.мСохраненныйДок.Организация              = СтруктураРеквизитовФормы.Организация;
	СтруктураРеквизитовФормы.мСохраненныйДок.ДатаПодписи              = ДатаПодписи;	
	СтруктураРеквизитовФормы.мСохраненныйДок.ЕдиницаИзмерения         = Неопределено;	
	СтруктураРеквизитовФормы.мСохраненныйДок.ТочностьЕдиницыИзмерения = СтруктураРеквизитовФормы.ТочностьЕдиницыИзмерения;	
	СтруктураРеквизитовФормы.мСохраненныйДок.ВидОтчетности            = Перечисления.ВидыОтчетности.РегламентированнаяОтчетность;	
	СтруктураРеквизитовФормы.мСохраненныйДок.Вид                      = Вариант;	
	СтруктураРеквизитовФормы.мСохраненныйДок.ПредставлениеВида        = РегламентированнаяОтчетность.ПредставлениеВидаДокумента(СтруктураРеквизитовФормы.мСохраненныйДок.Вид);	
	СтруктураРеквизитовФормы.мСохраненныйДок.Комментарий              = Комментарий;
	
	СтруктураРеквизитовФормы.мВариант = Вариант;

	// формируем список сохранения
	СписокСохранения = Новый Структура();
	
	// вставляем данные редактируемых ячеек таблицы	
	СписокСохранения.Вставить("ПоказателиОтчета", ПоказателиОтчета);

	// вставляем данные многострочных разделов
	СписокСохранения.Вставить("ДанныеМногострочныхРазделов", Неопределено);

	// вставляем данные вариантов автозаполнения ячеек
	СписокСохранения.Вставить("ДанныеВариантовАвтоЗаполнения", Неопределено);

	// вствляем версию формы
	СписокСохранения.Вставить("ВерсияФормы", СтруктураРеквизитовФормы.мВерсияФормы);

	ХранилищеДанных = Новый ХранилищеЗначения(СписокСохранения);
	СтруктураРеквизитовФормы.мСохраненныйДок.ДанныеОтчета = ХранилищеДанных;

	// ПроцессыОбработкиДокументов
	//
	РегламентированнаяОтчетность.ПередЗаписьюНаСервере(ЭтотОбъект,
		СтруктураРеквизитовФормы.мСохраненныйДок, Новый Структура);
	//
	// ПроцессыОбработкиДокументов
	
	// записываем документ, хранящий данные отчета
	Попытка
		СтруктураРеквизитовФормы.мСохраненныйДок.Записать();
	Исключение
		
		Если НЕ Автосохранение Тогда
			
			Сообщение = Новый СообщениеПользователю;

			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																							|en = '%1'"), РегламентированнаяОтчетностьКлиентСервер.СформироватьТекстСообщения(ОписаниеОшибки()));

			Сообщение.Сообщить();
				
		КонецЕсли;
		
		СтруктураРеквизитовФормы.мСохраненныйДок = СтруктураРеквизитовФормы.мСохраненныйДок.Ссылка;
		
		Возврат Ложь;
		
	КонецПопытки;
	
	// ПроцессыОбработкиДокументов
	//
	РегламентированнаяОтчетность.ПослеЗаписиНаСервере(ЭтотОбъект,
		СтруктураРеквизитовФормы.мСохраненныйДок, Новый Структура);
	//
	// ПроцессыОбработкиДокументов
	
	Модифицированность   = Ложь;
	
	СтруктураРеквизитовФормы.мСохраненныйДок = СтруктураРеквизитовФормы.мСохраненныйДок.Ссылка;
	
	Если НЕ СтруктураРеквизитовФормы.мБезОткрытияФормы
       И НЕ СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено Тогда
				   
    	ЗаблокироватьДанныеДляРедактирования(СтруктураРеквизитовФормы.мСохраненныйДок, , ЭтаФорма.УникальныйИдентификатор);

    КонецЕсли;
	
	Если ДанныеДляРазблокирования <> Неопределено Тогда
		РазблокироватьДанныеДляРедактирования(ДанныеДляРазблокирования.Ключ, ДанныеДляРазблокирования.ИдФормы);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // Сохранить()

&НаКлиенте
Функция СобратьДанныеТекущегоТаблПоляНаКлиенте(ИмяТабличногоПоля) Экспорт
	
	Возврат РегламентированнаяОтчетностьКлиентСервер.СобратьДанныеТекущегоТаблПоля(ЭтаФорма, ИмяТабличногоПоля);
	
КонецФункции // СобратьДанныеТекущегоТаблПоляНаКлиенте()

&НаСервере
Функция СобратьДанныеТекущегоТаблПоляНаСервере(ИмяТабличногоПоля) Экспорт
	
	Возврат РегламентированнаяОтчетностьКлиентСервер.СобратьДанныеТекущегоТаблПоля(ЭтаФорма, ИмяТабличногоПоля);

КонецФункции // СобратьДанныеТекущегоТаблПоляНаСервере()

&НаСервере
Функция ПередСохранением(КодИФНС = "не применимо", ПодобныйОтчетСуществует="", Вариант="", ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки="", Автосохранение="", ПоказателиОтчета="")
	
	Если РегламентированнаяОтчетность.БылиИзмененыКлючевыеРеквизитыОтчета(ЭтаФорма, КодИФНС)
	   И РегламентированнаяОтчетность.СуществуетДокументСАналогичнымиРеквизитами(ЭтаФорма, КодИФНС) Тогда
		
		ПодобныйОтчетСуществует = Истина;
		
	КонецЕсли;
	
	СтруктураРеквизитовФормы.мЗаписываетсяНовыйДокумент = (СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено ИЛИ СтруктураРеквизитовФормы.мСкопированаФорма <> Неопределено);
	
	Если Вариант <> Неопределено И ((СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено) ИЛИ (СтруктураРеквизитовФормы.мСкопированаФорма <> Неопределено) ИЛИ (Вариант <> СтруктураРеквизитовФормы.мВариант)) Тогда
		
		Если СтруктураРеквизитовФормы.мСохраненныйДок = Неопределено ИЛИ СтруктураРеквизитовФормы.мСкопированаФорма <> Неопределено Тогда
						
		ИначеЕсли Вариант <> СтруктураРеквизитовФормы.мВариант Тогда
			
			ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки = Истина;
								
		КонецЕсли;

	КонецЕсли;
	
	Если ПодобныйОтчетСуществует
	 ИЛИ ОткрытьФормуВопросаПриИзмененииВидаДокументаНомераКорректировки Тогда
	 
	 	Возврат Ложь;
		
 	КонецЕсли;
		
	Возврат Сохранить(Автосохранение, КодИФНС, Вариант, , ПоказателиОтчета);
		
КонецФункции // ПередСохранением()

&НаКлиенте
Процедура Обновить(Команда)
	
	СтруктураРеквизитовФормы.мВПрограммеИзмененаОрганизация = Истина;
	ЗаполнитьСведенияОбОрганизацииНаКлиенте();
	СтруктураРеквизитовФормы.мВПрограммеИзмененаОрганизация = Ложь;
	Модифицированность = Истина;
	
КонецПроцедуры // Обновить()

&НаКлиенте
Процедура ОчиститьОтчет(Команда)
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Внимание! Будут очищены все показатели отчета.%1Продолжить операцию?';
																				|en = 'Внимание! Будут очищены все показатели отчета.%1Продолжить операцию?'"), Символы.ПС);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОчиститьОтчетЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтчетЗавершение(Ответ, ДополнительныеПараметры) Экспорт
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда      
        Возврат;        
    Иначе       
        Очистить();       
    КонецЕсли;

КонецПроцедуры // ОчиститьОтчет()

&НаКлиенте
Процедура Очистить() Экспорт
		
	ОчиститьТабличноеПолеНаСервере();

	// устанавливаем флаг модифицированности формы
	Модифицированность = Истина;

КонецПроцедуры // Очистить()

&НаСервере
Процедура ОчиститьТабличноеПолеНаСервере()
	
	ОчиститьТабличноеПоле(ЭтаФорма);
	РасчетНаСервере();
	
КонецПроцедуры // ОчиститьТабличноеПолеНаСервере()

// Процедура очищает содержимое редактируемыхи и вычисляемых ячеек
// поля табличного документа, переданного параметром ВыбТабличноеПоле.
//
// Параметры:
//  ВыбТабличноеПоле - поле табличного документа.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьТабличноеПоле(Форма)
	
	// Список ячеек, очищать которые не нужно
	Перем СписокПоказателейНеПодлежащихОчистке;

	ВыбТабличноеПоле = Форма.ПолеТабличногоДокументаФормаОтчета;
	
	СписокПоказателейНеПодлежащихОчистке = Новый СписокЗначений;
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргНазв");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргАдрес");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодОКПО");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргВидДеят");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодОКВЭД");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодНазв1");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодНазв2");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодЗнач");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргКодЗнач1");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргДолжностьИсп");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргИсполнитель");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ОргТелефонИсп");
	СписокПоказателейНеПодлежащихОчистке.Добавить("ДатаСоставленияОтчета");
	СписокПоказателейНеПодлежащихОчистке.Добавить("НомерКорректировки");

	Для Инд = 0 По ВыбТабличноеПоле.Области.Количество() - 1 Цикл
		ТекущаяОбласть = ВыбТабличноеПоле.Области[Инд];
		
		// Ячейки не подлежащие очистки
		Если СписокПоказателейНеПодлежащихОчистке.НайтиПоЗначению(ТекущаяОбласть.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если Не ТекущаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
			Продолжить;
		КонецЕсли;

		Если Не ТекущаяОбласть.СодержитЗначение Тогда
			Продолжить;
		КонецЕсли;

		Если ТекущаяОбласть.Защита Тогда
			Продолжить;
		КонецЕсли;

		ТекущаяОбласть.Очистить();
	КонецЦикла;
	
	Расчет();

КонецПроцедуры // ОчиститьТабличноеПоле()

// РасчетНаКлиенте()
//
&НаКлиенте
Процедура РасчетНаКлиенте(ИмяСтраницыПанели = "") Экспорт

	Расчет(ИмяСтраницыПанели);

КонецПроцедуры // РасчетНаКлиенте()

// РасчетНаСервере()
//
&НаСервере
Процедура РасчетНаСервере(ИмяСтраницыПанели = "") Экспорт

	Расчет(ИмяСтраницыПанели);

КонецПроцедуры // РасчетНаСервере()

// Выполняет расчет вычисляемых показателей отчета
// (ячеек, выделенных зеленым цветом).
//
&НаКлиентеНаСервереБезКонтекста
Процедура Расчет(ИмяСтраницыПанели = "") 

	// Процедура заглушка для универсальности, не удалять.
	Возврат;

КонецПроцедуры // Расчет()

&НаКлиенте
Процедура ПолеТабличногоДокументаФормаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	//
	Если Элементы.ПолеТабличногоДокументаФормаОтчета.Защита Тогда
		
		Возврат;
		
	КонецЕсли;
	//
	// ПроцессыОбработкиДокументов
	
	Если Область.Имя = "ОргАдрес" Тогда
		РегламентированнаяОтчетностьКлиент.ОбработкаАдресаВСтатистическомОтчете(ЭтаФорма, Область, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	РегламентированнаяОтчетностьКлиент.ОбновитьАдресВТабличномДокументеСтатистическойОтчетности(Результат, Параметры.Область, СтруктураРеквизитовФормы);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаФормаОтчетаПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	// ПроцессыОбработкиДокументов
	//
	Если Элементы.ПолеТабличногоДокументаФормаОтчета.Защита Тогда
		
		Возврат;
		
	КонецЕсли;
	//
	// ПроцессыОбработкиДокументов
	
	Если Область.Имя = "ДатаСоставленияОтчета" Тогда 
		ДатаПодписи = Область.Значение;
		ЗаполнитьСведенияОбОрганизацииНаКлиенте(Истина);
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли Область.Имя = "НомерКорректировки" Тогда 
		Если Область.Значение = 0 Тогда 
			СтруктураРеквизитовФормы.ВидДокумента = 0;
			НомерКорректировки = 0;
		Иначе 
			СтруктураРеквизитовФормы.ВидДокумента = 1;
			НомерКорректировки = Область.Значение;
		КонецЕсли;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	РасчетНаКлиенте();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБланк(Команда)
	
	Отказ = Ложь;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Команда", Команда);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьБланкЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПередПечатьюРегламентированногоОтчета(ОписаниеОповещения, ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБланкЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Команда = ДополнительныеПараметры.Команда;
		
	Если Команда <> Неопределено Тогда
		Печать(Команда.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(ВидПечати, НеИзФормыОтчета = Ложь) Экспорт
    
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1. Формируется печатная форма...';
																			|en = '%1. Формируется печатная форма...'"), ЭтаФорма.Заголовок), , , БиблиотекаКартинок.Печать);
	
	Если НЕ ПечатьНаСервере(ВидПечати) Тогда
		Возврат;
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтаФорма, ВидПечати, Неопределено, СтруктураРеквизитовФормы.СписокПечатаемыхЛистов);
			
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере(ВидПечати)
	
	Если НЕ РегламентированнаяОтчетность.ПринтерДоступен() Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru = 'Перед формированием печатных форм необходимо определить в системе принтер и задать его в качестве используемого по умолчанию!';
								|en = 'Перед формированием печатных форм необходимо определить в системе принтер и задать его в качестве используемого по умолчанию!'");

		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтруктураРеквизитовФормы.мПечатныеФормы.Очистить();
	
	ОбластиСтроки = Новый Структура;
	
	Для Каждого Обл Из ПолеТабличногоДокументаФормаОтчета.Области Цикл
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки И Обл.Имя <> "ПолеНомерКорректировки" Тогда
			ОбластиСтроки.Вставить(Обл.Имя, ПолеТабличногоДокументаФормаОтчета.ПолучитьОбласть(Обл.Имя));
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ОбластиСтроки Цикл
		ПечатнаяФорма = Новый ТабличныйДокумент();
		ПечатнаяФорма.ОтображатьЗаголовки = Ложь;
		ПечатнаяФорма.ОтображатьСетку     = Ложь;
		ПечатнаяФорма.ЧерноБелыйПросмотр  = Истина;
		ПечатнаяФорма.ЧерноБелаяПечать    = Истина;
		ПечатнаяФорма.Автомасштаб         = Истина;
		ПечатнаяФорма.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
		ПечатнаяФорма.Вывести(Обл.Значение);
		СтруктураРеквизитовФормы.мПечатныеФормы.Добавить(ПечатнаяФорма, "Форма П-2 (краткая)");
	КонецЦикла;
	
	РегламентированнаяОтчетность.УдалитьНомерКорректировки(СтруктураРеквизитовФормы.мПечатныеФормы[0].Значение);
	РегламентированнаяОтчетностьКлиентСервер.ПроставлениеНомеровЛистов(ЭтаФорма, , СтруктураРеквизитовФормы.СписокПечатаемыхЛистов);
	
	Возврат Истина;
	
КонецФункции

// ЗаполнитьДатуВЯчейкахНаСервере()
//
&НаСервере
Процедура ЗаполнитьДатуВЯчейкахНаСервере() Экспорт
    	
	ЗаполнитьДатуВЯчейках(ЭтаФорма);
		
КонецПроцедуры // ЗаполнитьДатуВЯчейкахНаСервере()

// ЗаполнитьДатуВЯчейкахНаКлиенте()
//
&НаКлиенте
Процедура ЗаполнитьДатуВЯчейкахНаКлиенте() Экспорт
    	
	ЗаполнитьДатуВЯчейках(ЭтаФорма);
	
КонецПроцедуры // ЗаполнитьДатуВЯчейкахНаКлиенте()

// Заполняет дату подписания отчета должностными лицами, в зависимости от
// наличия данных по этим лицам.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДатуВЯчейках(Форма)
	
	// Процедура "заглушка", для роОчистить.
	Возврат;
              		
КонецПроцедуры // ЗаполнитьДатуВЯчейках()

&НаКлиенте
Процедура  ЗаписатьИЗакрыть(Команда)
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", ЭтаФорма);
	Оповещение = Новый ОписаниеОповещения("ПослеСохраненияФормыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	СохранитьНаКлиенте(, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ДополнительныеПараметры.Форма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьОтчетИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#Область ОбработчикиСобытийФормы

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
		
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	
	РегламентированнаяОтчетностьКлиент.ВыполнитьЗадачу(
		ЭтотОбъект,
		Команда,
		?(ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок),
			СтруктураРеквизитовФормы.мСохраненныйДок,
			СтруктураРеквизитовФормы.ПустаяСсылкаНаРегламентированныйОтчет));
	
КонецПроцедуры

#КонецОбласти

#Область ПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	
	РегламентированнаяОтчетностьКлиент.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РегламентированнаяОтчетностьКлиент.КомментарийСледующемуНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцессыОбработкиДокументов

&НаКлиенте
Процедура Записать(ПараметрыЗаписи) Экспорт
	
	СохранитьНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	
	РегламентированнаяОтчетность.ВыполнитьЗадачу(ЭтотОбъект, Контекст, СтруктураРеквизитовФормы.мСохраненныйДок);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюРеквизитов(БлокируемыеЭлементы, ТолькоПросмотр) Экспорт
	
	РегламентированнаяОтчетность.УправлениеДоступностьюРеквизитов(ЭтотОбъект, БлокируемыеЭлементы, ТолькоПросмотр);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
