
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	ВосстановитьНастройки(Параметры);
	
	НастроитьФорму(Параметры);
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		НавигационнаяСсылка = "e1cib/command/Обработка.ЖурналДокументовИнтеркампани.Команда.ПередачиКОформлению";
	Иначе
		НавигационнаяСсылка = "e1cib/command/ОбщаяКоманда.ВыкупыТоваровПринятыхКОформлению";
	КонецЕсли;
	
	ПоляШапки = Новый ФиксированнаяСтруктура(ЗапасыСервер.ПоляШапкиПриОформленииПоРезервамТоваровОрганизаций());
	
	Элементы.ДекорацияЕстьЛишниеРезервы.Видимость          = Ложь;	
	Элементы.ДекорацияЕстьОшибкаПереносаРезервов.Видимость = Ложь;	
	Элементы.ДекорацияОформитьПередачи.Видимость           = Ложь;
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ПередачаТоваровМеждуОрганизациями) Тогда
		Элементы.ДекорацияОформитьПередачи.Заголовок = Строка(Элементы.ДекорацияОформитьПередачи.Заголовок);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПередачаТоваровМеждуОрганизациями"
		Или ИмяСобытия = "Запись_ВыкупПринятыхНаХранениеТоваров"
		Тогда
		
		ЗаполнитьКОформлениюЗаПериод();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОчиститьСообщения();
	
	Период.ДатаНачала		= НачалоМесяца(Период.ДатаНачала);
	Период.ДатаОкончания	= ?(ЗначениеЗаполнено(Период.ДатаОкончания),
								КонецМесяца(Период.ДатаОкончания),
								Период.ДатаОкончания);
	
	Если Период.ДатаНачала > Период.ДатаОкончания
		И ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		
		ТекстСообщения = НСтр("ru = 'Дата начала периода не может быть больше даты окончания периода';
								|en = 'The period start date cannot be greater than the period end date'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Период");
		
		Период.ДатаОкончания = КонецМесяца(Период.ДатаНачала);
		
	КонецЕсли;
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправительПриИзменении(Элемент)
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияПриИзменении(Элемент)
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если МестоХранения = Неопределено
		И ОформляемыеДокументы = "ТолькоВыкупы" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СписокВыбора = Новый СписокЗначений();
		СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка"), НСтр("ru = 'Склад (складская территория)';
																								|en = 'Warehouse (warehouse area)'"));
		СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка"), НСтр("ru = 'Подразделение';
																											|en = 'Business unit'"));
		СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка"), НСтр("ru = 'Договоры контрагентов';
																											|en = 'Counterparty contracts'"));
		
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(
			"ПослеВыбораТипаМестаХранения",
			ЭтаФорма);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗначенияДляВыбора", СписокВыбора);
		ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru = 'Выбор типа данных';
													|en = 'Select data type'"));
		
		ОткрытьФорму(
			"ОбщаяФорма.ВыборЗначенияИзСписка",
			ПараметрыОткрытия,
			ЭтаФорма,
			Новый УникальныйИдентификатор(),
			,
			,
			ОписаниеОповещенияОЗакрытии,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(МестоХранения) = Тип("СправочникСсылка.Склады") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуВыбораСклада();
	ИначеЕсли ТипЗнч(МестоХранения) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуВыбораПодразделения();
	ИначеЕсли ТипЗнч(МестоХранения) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуВыбораДоговора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораТипаМестаХранения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеМестоХранения = Результат;
	
	Если ТипЗнч(ВыбранноеМестоХранения) = Тип("СправочникСсылка.Склады") Тогда
		ОткрытьФормуВыбораСклада();
	ИначеЕсли ТипЗнч(ВыбранноеМестоХранения) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		ОткрытьФормуВыбораПодразделения();
	ИначеЕсли ТипЗнч(ВыбранноеМестоХранения) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ОткрытьФормуВыбораДоговора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораСклада()
	
	ОткрытьФорму("Справочник.Склады.Форма.ФормаВыбора",
		,
		Элементы.МестоХранения,
		Элементы.МестоХранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодразделения()
	
	ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.ФормаВыбора",
		,
		Элементы.МестоХранения,
		Элементы.МестоХранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораДоговора()
	
	СтруктураОтбора = Новый Структура();
	СтруктураПараметровВыбора = Новый Структура();
	//++ НЕ УТКА
	Если КлючНазначенияИспользования = "ДокументыЗакупки"
		Или КлючНазначенияИспользования = "ЗакрытиеМесяца" Тогда
	//-- НЕ УТКА
		СтруктураОтбора.Вставить(
			"ХозяйственнаяОперация",
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи"));
	//++ НЕ УТКА
	КонецЕсли;
	
	Если КлючНазначенияИспользования = "ДокументыПриемаВПереработку"
		Или КлючНазначенияИспользования = "ЗакрытиеМесяца" Тогда
		СтруктураОтбора.Вставить(
			"ХозяйственнаяОперация",
			ДавальческаяСхемаКлиентСервер.ХозяйственнаяОперацияДоговора());
	КонецЕсли;
	//-- НЕ УТКА
	
	СтруктураПараметровВыбора.Вставить("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора",
		СтруктураПараметровВыбора,
		Элементы.МестоХранения,
		Элементы.МестоХранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЕстьОшибкаПереносаРезервовОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗапускатьНеВФоне", Истина);
	ПараметрыОтбора.Вставить("ДатаНачала", ВремяНачалаПереноса);
	ПараметрыОтбора.Вставить("СобытиеЖурналаРегистрации", ИмяСобытияПереносаРезервов());
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ПараметрыОтбора);

КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ОбработкаНавигационнойСсылкиСмТакжеПерейти(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СсылкаПерейтиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ОбработкаНавигационнойСсылкиСмТакжеПерейти(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОформитьПередачиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыПередач = Новый Структура;
	ПараметрыФормыПередач.Вставить("КлючНазначенияИспользования", "ДокументыИнтеркампани");
	
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("Организация", Получатель);
	ОтборыФормыСписка.Вставить("МестоХранения", МестоХранения);
	
	ПараметрыФормыПередач.Вставить("ОтборыФормыСписка", ОтборыФормыСписка);
	
	ОткрытьФорму("Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп",
				ПараметрыФормыПередач,
				,
				"ДокументыИнтеркампани");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЕстьЛишниеРезервыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПеренестиРезервы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьДокументЗаПериод(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
	"Обработка.ЖурналДокументовИнтеркампани.РабочееМестоПередачиВыкуп.Команда.ОформитьДокументЗаПериод");
	
	Строка = Элементы.КОформлениюЗаПериод.ТекущиеДанные;
	
	Если Не ОбщегоНазначенияУТКлиент.ВыбраныДокументыКОформлению(
		Строка, ПараметрыЖурнала()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Строка <> Неопределено Тогда
		
		СтруктураПолейШапки = Новый Структура(ПоляШапки);
		
		ЗаполнитьЗначенияСвойств(СтруктураПолейШапки, Строка);
		
		Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
			ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
		Иначе
			ИмяФормыОткрытия = "Документ.ВыкупПринятыхНаХранениеТоваров.ФормаОбъекта";
		КонецЕсли;
		
		Основание = Новый Структура;
		Основание.Вставить("ПоляШапки", СтруктураПолейШапки);
		Основание.Вставить("ЗаполнятьПоРезервамТоваровОрганизаций");
		
		СтруктураПараметры = Новый Структура("Основание", Основание);
		
		ОткрытьФорму(ИмяФормыОткрытия, СтруктураПараметры, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьКОформлениюЗаПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРезервы(Команда)
	
	СвернутьРезервыСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКОформлениюЗаПериод

&НаКлиенте
Процедура КОформлениюЗаПериодПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПеренестиРезервы

&НаКлиенте
Процедура ПеренестиРезервы()		
	
	Элементы.ДекорацияЕстьЛишниеРезервы.Видимость = Ложь;
	
	ФоновоеЗадание = ПеренестиРезервыСервер();
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Истина;
	Обработчик = Новый ОписаниеОповещения("ПослеЗаполненияКОформлениюЗаПериод", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервере
Функция ПеренестиРезервыСервер()
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Перенос резервов товаров организаций';
																|en = 'Transfer company goods reserves'");
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("Обработки.ЖурналДокументовИнтеркампани.РаспределитьРезервыПоПериодам",
		ПараметрыЗаполненияКОформлениюЗаПериод(), ПараметрыВыполненияВФоне);
		
	ВремяНачалаПереноса = ТекущаяДатаСеанса();
		
	Возврат ФоновоеЗадание;
	
КонецФункции

#КонецОбласти


#Область ЗаполнитьКОформлениюЗаПериод

&НаКлиенте
Процедура ЗаполнитьКОформлениюЗаПериод()		
	
	Элементы.ДекорацияЕстьЛишниеРезервы.Видимость = Ложь;
	Элементы.ДекорацияЕстьОшибкаПереносаРезервов.Видимость = Ложь;
	
	ФоновоеЗадание = ЗаполнитьКОформлениюЗаПериодСервер();
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Истина;
	Обработчик = Новый ОписаниеОповещения("ПослеЗаполненияКОформлениюЗаПериод", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьКОформлениюЗаПериодСервер()
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Перенос резервов товаров организаций';
																|en = 'Transfer company goods reserves'");
	
	ВремяНачалаПереноса = ТекущаяДатаСеанса();
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("Обработки.ЖурналДокументовИнтеркампани.ЗаполнитьКОформлениюЗаПериод",
		ПараметрыЗаполненияКОформлениюЗаПериод(), ПараметрыВыполненияВФоне);
		
	Возврат ФоновоеЗадание;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаполненияКОформлениюЗаПериод(ФоновоеЗадание, ДополнительныеПараметры) Экспорт
	
	Если ФоновоеЗадание <> Неопределено 
		И ФоновоеЗадание.Статус = "Выполнено" Тогда
	
		Если ЭтоАдресВременногоХранилища(ФоновоеЗадание.АдресРезультата) Тогда
			ЗагрузитьКОформлениюЗаПериод(ФоновоеЗадание.АдресРезультата);
		КонецЕсли;
		
	Иначе
		Если ФоновоеЗадание <> Неопределено Тогда
			ОписаниеОшибки = НСтр("ru = 'Не удалось закончить выполнения задания по причине: %Причина%';
									|en = 'Cannot complete job. Reason: %Причина%'");
			ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Причина%",  ФоновоеЗадание.ПодробноеПредставлениеОшибки);
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
		КОформлениюЗаПериод.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКОформлениюЗаПериод(АдресВоВременномХранилище)
	
	Результат = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище); 
	
	Если Результат.КОформлениюЗаПериод <> Неопределено Тогда  
		КОформлениюЗаПериод.Загрузить(Результат.КОформлениюЗаПериод);
	Иначе
		КОформлениюЗаПериод.Очистить();
	КонецЕсли;
	
	Элементы.ДекорацияЕстьЛишниеРезервы.Видимость          = Результат.ЛишниеРезервы = "ЕстьЛишниеРезервы";	
	Элементы.ДекорацияЕстьОшибкаПереносаРезервов.Видимость = Результат.ЛишниеРезервы = "Ошибка";	
	Элементы.ДекорацияОформитьПередачи.Видимость           = Результат.ЕстьТоварыКОформлениюПередачПередВыкупом;
	
КонецПроцедуры

// Функция-конструктор параметров
// 
// Возвращаемое значение:
// 	Структура - где:
// * МестоХранения - СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.СтруктураПредприятия, СправочникСсылка.Склады - 
// * Получатель - СправочникСсылка.Организации
// * Отправитель - СправочникСсылка.Организации, СправочникСсылка.Партнеры - 
// * Период - СтандартныйПериод
// * ОформлятьВыкупы - Булево
// * ОформлятьПередачи - Булево
&НаСервере
Функция ПараметрыЗаполненияКОформлениюЗаПериод()
	
	ПараметрыЗаполнения = Новый Структура;
	
	ПараметрыЗаполнения.Вставить("ОформлятьПередачи", ОформляемыеДокументы = "ТолькоПередачи"); 
	ПараметрыЗаполнения.Вставить("ОформлятьВыкупы",   ОформляемыеДокументы = "ТолькоВыкупы"); 
	ПараметрыЗаполнения.Вставить("Период",            Период);
	ПараметрыЗаполнения.Вставить("Отправитель",       Отправитель);
	ПараметрыЗаполнения.Вставить("Получатель",        Получатель);
	ПараметрыЗаполнения.Вставить("МестоХранения",     МестоХранения);
	ПараметрыЗаполнения.Вставить("ТипыЗапасовВыкупа", Новый Массив);
	Если ПараметрыЗаполнения.ОформлятьВыкупы Тогда
		Если КлючНазначенияИспользования = "ДокументыЗакупки"
			Или КлючНазначенияИспользования = "ЗакрытиеМесяца" Тогда
			ПараметрыЗаполнения.ТипыЗапасовВыкупа.Добавить(Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи);
		КонецЕсли;
		//++ НЕ УТКА
		Если КлючНазначенияИспользования = "ДокументыПриемаВПереработку"
			Или КлючНазначенияИспользования = "ЗакрытиеМесяца" Тогда
			ПараметрыЗаполнения.ТипыЗапасовВыкупа.Добавить(Перечисления.ТипыЗапасов.МатериалДавальца);
			ПараметрыЗаполнения.ТипыЗапасовВыкупа.Добавить(Перечисления.ТипыЗапасов.ПолуфабрикатДавальца);
			ПараметрыЗаполнения.ТипыЗапасовВыкупа.Добавить(Перечисления.ТипыЗапасов.ПродукцияДавальца);
		КонецЕсли;
		//-- НЕ УТКА
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "КОформлениюЗаПериод.Период",
		"КОформлениюЗаПериодПериод");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиСмТакжеПерейти(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтборыФормыСписка = Новый Структура;
	ОтборыФормыСписка.Вставить("МестоХранения", МестоХранения);
	
	ПараметрыЖурнала = Новый Структура;
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		ОтборыФормыСписка.Вставить("Организация", Отправитель);
		
		ПараметрыЖурнала.Вставить("КлючНазначенияИспользования", "ПередачаТоваровМеждуОрганизациями");
	ИначеЕсли КлючНазначенияИспользования = "ЗакрытиеМесяца" Тогда
		ОтборыФормыСписка.Вставить("Организация", Получатель);
		ПараметрыЖурнала.Вставить("КлючНазначенияИспользования", КлючНазначенияИспользования);
	Иначе
		ОтборыФормыСписка.Вставить("Организация", Получатель);
		ПараметрыЖурнала.Вставить("КлючНазначенияИспользования", "ВыкупПринятыхНаХранениеТоваров");
	КонецЕсли;
	
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора", ОтборыФормыСписка);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыЖурнала);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ДокументыИнтеркампани";
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройки(Параметры)
	Если Параметры.Свойство("КлючНазначенияИспользования")
		И ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		
		КлючНазначенияИспользования = Параметры.КлючНазначенияИспользования;
		
	Иначе
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	КонецЕсли;
	
	ОформлениеПередач = КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		ФормаОткрытаПоГиперссылке = Истина;
		
		Если ОформлениеПередач Тогда
			Получатель  = Параметры.Организация;
			Отправитель = Параметры.Организация;
		Иначе
			Получатель = Параметры.Организация;
		КонецЕсли;
		
		ДатаНачала     = НачалоМесяца(Параметры.ПериодРегистрации);
		ДатаОконачания = КонецМесяца(Параметры.ПериодРегистрации);
		
		Период.ДатаНачала    = ДатаНачала;
		Период.ДатаОкончания = ДатаОконачания;
		
	ИначеЕсли Параметры.Свойство("ОтборыФормыСписка") Тогда
		
		ФормаОткрытаПоГиперссылке = Истина;
		ОтборыФормыСписка = Параметры.ОтборыФормыСписка;
		
		Если ОформлениеПередач Тогда
			Отправитель = ОтборыФормыСписка.Организация;
		Иначе
			Получатель = ОтборыФормыСписка.Организация;
		КонецЕсли;
		
		Если ОтборыФормыСписка.Свойство("Склад") Тогда
			МестоХранения = ОтборыФормыСписка.Склад;
		Иначе
			МестоХранения = ОтборыФормыСписка.МестоХранения;
		КонецЕсли;
		
	ИначеЕсли Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		
		ФормаОткрытаПоГиперссылке = Истина;
		ОтборыФормыСписка = Параметры.СтруктураБыстрогоОтбора;
		
		Если ОформлениеПередач Тогда
			Отправитель = ОтборыФормыСписка.Организация;
		Иначе
			Получатель = ОтборыФормыСписка.Организация;
		КонецЕсли;
		
		Если ОтборыФормыСписка.Свойство("Склад") Тогда
			МестоХранения = ОтборыФормыСписка.Склад;
		Иначе
			МестоХранения = ОтборыФормыСписка.МестоХранения;
		КонецЕсли;
		
	Иначе
		
		ФормаОткрытаПоГиперссылке = Ложь;
		
		КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп";
		Настройки   = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНазначенияИспользования); // см. ПараметрыЗаполненияКОформлениюЗаПериод
		
		Если Настройки <> Неопределено Тогда
			Период               = Настройки.Период;
			Отправитель          = Настройки.Отправитель;
			Получатель           = Настройки.Получатель;
			ОформляемыеДокументы = Настройки.ОформляемыеДокументы;
			Если Настройки.Свойство("МестоХранения") Тогда
				МестоХранения    = Настройки.МестоХранения;
			ИначеЕсли Настройки.Свойство("Склад") Тогда
				МестоХранения    = Настройки.Склад;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОформляемыеДокументы) Тогда
		ОформляемыеДокументы = ?(ОформлениеПередач, "ТолькоПередачи", "ТолькоВыкупы");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму(Параметры)
	
	ПараметрыФормирования = Новый Структура;
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	Если ОформляемыеДокументы = "ТолькоПередачи" Тогда
		
		Заголовок = НСтр("ru = 'Передачи товаров к оформлению';
						|en = 'Intercompany invoices to register'");
		
		Отправитель = ?(ЗначениеЗаполнено(Отправитель), Отправитель, Справочники.Организации.ПустаяСсылка());
		МестоХранения = ?(ЗначениеЗаполнено(МестоХранения), МестоХранения, Справочники.Склады.ПустаяСсылка());
		
		Элементы.МестоХранения.ВыбиратьТип = Ложь;
		                                
		Элементы.МестоХранения.Видимость                         = ИспользоватьНесколькоСкладов;
		Элементы.КОформлениюЗаПериодМестоХранения.Видимость      = ИспользоватьНесколькоСкладов;
		Элементы.КОформлениюЗаПериодКонтрагент.Видимость = Ложь;
		Элементы.КОформлениюЗаПериодНалогообложениеНДС.Видимость = Истина;
		
		ПараметрыФормирования.Вставить("КлючНазначенияИспользования", "ПередачаТоваровМеждуОрганизациями");
		МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовИнтеркампани");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Выкупы товаров к оформлению';
						|en = 'Purchases invoices — VMI to register'");
		
		Отправитель = ?(ЗначениеЗаполнено(Отправитель), Отправитель, Справочники.Партнеры.ПустаяСсылка());
		
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.Поставщик", Истина);
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ПараметрВыбора);
		
		Элементы.Отправитель.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		
		ЗаголовокОтправитель = НСтр("ru = 'Поклажедатель';
									|en = 'Vendor'");
		//++ НЕ УТКА
		Если КлючНазначенияИспользования = "ДокументыПриемаВПереработку" Тогда
			ЗаголовокОтправитель = НСтр("ru = 'Давалец';
										|en = 'Material provider'");
		КонецЕсли;
		//-- НЕ УТКА
		
		Элементы.Отправитель.Заголовок                    = ЗаголовокОтправитель;
		Элементы.КОформлениюЗаПериодОтправитель.Заголовок = ЗаголовокОтправитель;
		
		ЗаголовокПолучатель = НСтр("ru = 'Организация';
									|en = 'Company'");
		Элементы.Получатель.Заголовок                    = ЗаголовокПолучатель;
		Элементы.КОформлениюЗаПериодПолучатель.Заголовок = ЗаголовокПолучатель;
		
		ЗаголовокСклада = НСтр("ru = 'Место хранения';
								|en = 'Warehouse'");
		Элементы.МестоХранения.Заголовок                    = ЗаголовокСклада;
		Элементы.КОформлениюЗаПериодМестоХранения.Заголовок = ЗаголовокСклада;
		
		Элементы.КОформлениюЗаПериодКонтрагент.Видимость         = Истина;
		Элементы.КОформлениюЗаПериодНалогообложениеНДС.Видимость = Ложь;
		
		ПараметрыФормирования.Вставить("КлючНазначенияИспользования", "ВыкупПринятыхНаХранениеТоваров");
		
		//++ НЕ УТКА
		Если КлючНазначенияИспользования = "ДокументыПриемаВПереработку" Тогда
			МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовПриемаВПереработку2_5");
		Иначе
		//-- НЕ УТКА
			МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовЗакупки");
		//++ НЕ УТКА
		КонецЕсли;
		//-- НЕ УТКА
		
	КонецЕсли;
	
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, ПараметрыФормирования);
	Элементы.СмТакжеВРаботе.Видимость = ЗначениеЗаполнено(СмТакжеВРаботе);
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив;
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ФормированиеПередачТоваровМеждуОрганизациямиИВыкупов");
	
	СсылкаПерейти = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, ПараметрыФормирования, НСтр("ru = 'Перейти:';
																																				|en = 'Go to:'")); 
	Элементы.СсылкаПерейти.Видимость = ЗначениеЗаполнено(СсылкаПерейти);
	
	Элементы.КОформлениюПоМесяцамСвернутьРезервы.Видимость = ОбщегоНазначенияУТ.РежимОтладки();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФормаОткрытаПоГиперссылке Тогда
		Возврат;
	КонецЕсли;
	
	КлючОбъекта = "Обработка.ЖурналДокументовИнтеркампани.Форма.РабочееМестоПередачиВыкуп";
	ИменаСохраняемыхРеквизитов = "Период,Отправитель,Получатель,МестоХранения,ОформляемыеДокументы";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура СвернутьРезервыСервер()
	
	РегистрыНакопления.РезервыТоваровОрганизаций.ВыполнитьСверткуРегистраРезервыТоваровОрганизаций();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСобытияПереносаРезервов()
	
	Возврат РегистрыНакопления.РезервыТоваровОрганизаций.ИмяСобытияПереносаРезервов();
	
КонецФункции

&НаКлиенте
Функция ПараметрыЖурнала()
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",   Получатель);
	СтруктураБыстрогоОтбора.Вставить("МестоХранения", МестоХранения);
	
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора",	СтруктураБыстрогоОтбора);
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста",			"ЖурналДокументовИнтеркампани");
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы",		КлючНазначенияИспользования);
	ПараметрыЖурнала.Вставить("СинонимЖурнала", НСтр("ru = 'Документы между организациями';
													|en = 'Documents between companies'"));
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

#КонецОбласти
