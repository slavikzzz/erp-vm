
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УказываетсяРегионализация = Параметры.УказываетсяРегионализация;
	УказываетсяТранспортноеСредствоПредприятия = Параметры.УказываетсяТранспортноеСредствоПредприятия;
	ОбязательностьНомераТранспортногоСредства  = Параметры.ОбязательностьНомераТранспортногоСредства;
	Если УказываетсяРегионализация Тогда
		АдресВоВременномХранилищеРегионализация = Параметры.АдресВоВременномХранилищеРегионализация;
		АдресВоВременномХранилищеТовары         = Параметры.АдресВоВременномХранилищеТовары;
	КонецЕсли;
	
	ВладелецСсылка          = Параметры.ВладелецСсылка;
	ЭтоМаршрутВозврата      = Параметры.ЭтоМаршрутВозврата;
	БлокироватьПервуюСтроку = Параметры.БлокироватьПервуюСтроку;
	ХозяйствующийСубъект    = Параметры.ХозяйствующийСубъект;
	ИмяПоляВидПродукции     = Параметры.ИмяПоляВидПродукции;
	
	Если ЗначениеЗаполнено(Параметры.АдресВоВременномХранилище) Тогда
		
		Данные = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
		
		Для Каждого СтрокаТЧ Из Данные Цикл
			
			НоваяСтрока = Маршрут.Добавить();
			
			НоваяСтрока.НомерСтроки        = Данные.Индекс(СтрокаТЧ) + 1;
			НоваяСтрока.Идентификатор      = СтрокаТЧ.Идентификатор;
			НоваяСтрока.Предприятие        = СтрокаТЧ.Предприятие;
			НоваяСтрока.Адрес              = СтрокаТЧ.Адрес;
			НоваяСтрока.АдресПредставление = СтрокаТЧ.АдресПредставление;
			НоваяСтрока.СПерегрузкой       = СтрокаТЧ.СПерегрузкой;
			НоваяСтрока.ДанныеАдреса       = СтрокаТЧ.ДанныеАдреса.Получить();
			
			НоваяСтрока.ТипТранспорта                 = СтрокаТЧ.ТипТранспорта;
			НоваяСтрока.НомерТранспортногоСредства    = СтрокаТЧ.НомерТранспортногоСредства;
			НоваяСтрока.НомерАвтомобильногоПрицепа    = СтрокаТЧ.НомерАвтомобильногоПрицепа;
			НоваяСтрока.НомерАвтомобильногоКонтейнера = СтрокаТЧ.НомерАвтомобильногоКонтейнера;
			
			Если УказываетсяТранспортноеСредствоПредприятия Тогда
				НоваяСтрока.ТранспортноеСредство = СтрокаТЧ.ТранспортноеСредство;
			КонецЕсли;
			
			Если УказываетсяРегионализация Тогда
				НоваяСтрока.РезультатПроверкиПравилРегионализации = СтрокаТЧ.РезультатПроверкиПравилРегионализации;
				НоваяСтрока.УсловияРегионализацииВыполнены        = СтрокаТЧ.УсловияРегионализацииВыполнены;
				НоваяСтрока.НомерМаршрутаПереданныйВСервис        = НоваяСтрока.НомерСтроки;
				НоваяСтрока.ИндексКартинкиРегионализации          = ИндексКартинкиРегионализации(
					НоваяСтрока.РезультатПроверкиПравилРегионализации,
					НоваяСтрока.УсловияРегионализацииВыполнены);
					
				Если НЕ ЗначениеЗаполнено(НоваяСтрока.РезультатПроверкиПравилРегионализации) Тогда
					РегионализацияКПроверке = Истина;
				КонецЕсли;
			КонецЕсли;
			
			СформироватьПредставлениеДанныхПунктаМаршрута(НоваяСтрока);
			
		КонецЦикла;
		
		СформироватьЗаголовокФормы(ЭтотОбъект);
		
	КонецЕсли;
	
	РежимРаботыФормы = Параметры.РежимРаботыФормы;
	
	Если РежимРаботыФормы.Свойство("ИзменятьСоставСтрок") Тогда
		Элементы.Маршрут.ИзменятьСоставСтрок = РежимРаботыФормы.ИзменятьСоставСтрок;
	КонецЕсли;
	
	Если НЕ УказываетсяРегионализация Тогда
		Элементы.ОтображениеРегионализации.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?';
				|en = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Отказ = Ложь;
		АдресВременногоХранилища = АдресВоВременномХранилище(ВладелецФормы.УникальныйИдентификатор, Отказ);
		Если НЕ Отказ Тогда
			Модифицированность = Ложь;
			Закрыть(АдресВременногоХранилища);
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МаршрутПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Маршрут");
	
	СформироватьЗаголовокФормы(ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Маршрут.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если УказываетсяРегионализация
		   И ТекущиеДанные.НомерСтроки <> ТекущиеДанные.НомерМаршрутаПереданныйВСервис
		   И НЕ РегионализацияКПроверке Тогда
			УстановкаРегионализацииКПроверкеСервер();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПослеУдаления(Элемент)
	Если УказываетсяРегионализация
	   И НЕ РегионализацияКПроверке Тогда
		УстановкаРегионализацииКПроверкеСервер();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ОткрытьФормуРедактированияПунктаМаршрута();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование И УказываетсяРегионализация Тогда
		ТекущиеДанные = Элементы.Маршрут.ТекущиеДанные;
		ТекущиеДанные.НомерМаршрутаПереданныйВСервис = 0;
		ТекущиеДанные.РезультатПроверкиПравилРегионализации =
			ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПустаяСсылка");
		ТекущиеДанные.УсловияРегионализацииВыполнены = Ложь;
		ТекущиеДанные.ИндексКартинкиРегионализации = ИндексКартинкиРегионализации(
			ТекущиеДанные.РезультатПроверкиПравилРегионализации,
			ТекущиеДанные.УсловияРегионализацииВыполнены);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Маршрут.ТекущиеДанные;
	
	Если Поле.Имя = "МаршрутИндексКартинкиРегионализации"
	 ИЛИ Поле.Имя = "МаршрутРезультатПроверкиПравилРегионализации" Тогда
		СтандартнаяОбработка = Ложь;
		Если ТекущаяСтрока.РезультатПроверкиПравилРегионализации =
			ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешеноПриВыполненииУсловий") Тогда
			ОткрытьФормуРегионализации(ТекущаяСтрока.НомерСтроки);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуРедактированияПунктаМаршрута(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиМаршруты

&НаКлиенте
Процедура МаршрутПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Маршрут.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДоступноВверхВниз = НЕ (БлокироватьПервуюСтроку И ТекущиеДанные.НомерСтроки = 1);
	
	Элементы.ФормаПереместитьВверх.Доступность         = ДоступноВверхВниз;
	Элементы.ФормаПереместитьВниз.Доступность          = ДоступноВверхВниз;
	Элементы.ФормаПереместитьВверхКонтекст.Доступность = ДоступноВверхВниз;
	Элементы.ФормаПереместитьВнизКонтекст.Доступность  = ДоступноВверхВниз;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПередУдалением(Элемент, Отказ)
	
	Если Элементы.Маршрут.ТекущиеДанные.НомерСтроки = 1 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Элементы.Маршрут.ВыделенныеСтроки.Найти(0) <> Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	АдресВХ = АдресВоВременномХранилище(ВладелецФормы.УникальныйИдентификатор, Отказ);
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Закрыть(АдресВХ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	МаршрутПереместитьВверхВниз("Вверх");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	МаршрутПереместитьВверхВниз("Вниз");
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПереместитьВверхВниз(Направление)
	
	ТекущиеДанные = Элементы.Маршрут.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Направление = "Вверх" Тогда
		
		Если (БлокироватьПервуюСтроку И ТекущиеДанные.НомерСтроки <= 2)
			ИЛИ (НЕ БлокироватьПервуюСтроку И ТекущиеДанные.НомерСтроки = 1) Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Направление = "Вниз" Тогда
		
		Если (БлокироватьПервуюСтроку И ТекущиеДанные.НомерСтроки = 1)
			ИЛИ ТекущиеДанные.НомерСтроки = Маршрут.Количество() Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Маршрут.Сдвинуть(ТекущиеДанные.НомерСтроки-1, ?(Направление="Вниз", 1, -1));
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Маршрут");
	
	Элементы.Маршрут.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутТипТранспорта.Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутДанныеТранспортаСтрокой.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Маршрут.СПерегрузкой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<без перегрузки>';
																						|en = '<без перегрузки>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутДанныеТранспортаСтрокой.Имя);
	
	ГруппаОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Маршрут.СПерегрузкой");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Маршрут.НомерТранспортногоСредства");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Маршрут.ТипТранспорта");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыТранспортаВЕТИС.ПерегонСкота;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<необходимо указать>';
																						|en = '<необходимо указать>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутРезультатПроверкиПравилРегионализации.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Маршрут.РезультатПроверкиПравилРегионализации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УказываетсяРегионализация");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<необходимо проверить>';
																						|en = '<необходимо проверить>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255,0,0));
	
	//
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутНомерСтроки.Имя);
	ЭлементУсловногоОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутПунктМаршрутаСтрокой.Имя);
	ЭлементУсловногоОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутТипТранспорта.Имя);
	ЭлементУсловногоОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутДанныеТранспортаСтрокой.Имя);
	ЭлементУсловногоОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.МаршрутРезультатПроверкиПравилРегионализации.Имя);
	
	ГруппаОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Маршрут.НомерСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БлокироватьПервуюСтроку");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(242, 242, 242));
	
КонецПроцедуры

&НаСервере
Функция АдресВоВременномХранилище(УникальныйИдентификатор, Отказ = Ложь)
	
	Для каждого СтрокаТЧ Из Маршрут Цикл
		Если НЕ ТолькоПросмотр
		   И ЗначениеЗаполнено(СтрокаТЧ.Адрес)
		   И СтрокаТЧ.ДанныеАдреса = Неопределено Тогда
			Попытка
				СтрокаТЧ.ДанныеАдреса = ИнтеграцияВЕТИСВызовСервера.ДанныеАдресаПоАдресуXML(СтрокаТЧ.Адрес, СтрокаТЧ.АдресПредставление);
			Исключение
				ТекстОшибки = НСтр("ru = 'Не удалось преобразовать адрес по причине: %1. Перевыберите адрес.';
									|en = 'Не удалось преобразовать адрес по причине: %1. Перевыберите адрес.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ОписаниеОшибки());
				ИмяПоля = "Маршрут[" + Формат(Маршрут.Индекс(СтрокаТЧ), "ЧН=0; ЧГ=0") + "].ПунктМаршрутаСтрокой";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, ИмяПоля,, Отказ);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если УказываетсяРегионализация Тогда
		
		ТабличныеЧасти = Новый Структура("Маршрут, Товары, Регионализация");
		ТабличныеЧасти.Маршрут        = Маршрут.Выгрузить();
		ТабличныеЧасти.Товары         = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеТовары);
		ТабличныеЧасти.Регионализация = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеРегионализация);
		
		Результат = ПоместитьВоВременноеХранилище(ТабличныеЧасти, УникальныйИдентификатор);
		
	Иначе
		
		Результат = ПоместитьВоВременноеХранилище(Маршрут.Выгрузить(), УникальныйИдентификатор);
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьЗаголовокФормы(Форма)
	
	Форма.Заголовок = НСтр("ru = 'Пункты маршрута';
							|en = 'Пункты маршрута'") + ?(Форма.Маршрут.Количество(), " (" + Форма.Маршрут.Количество() + ")", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияПунктаМаршрута(ТекущаяСтрока = Неопределено)
	
	РежимРаботыФормыКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(РежимРаботыФормы, Ложь);
	
	Если БлокироватьПервуюСтроку И ТекущаяСтрока <> Неопределено И ТекущаяСтрока.НомерСтроки = 1 Тогда
		
		ВидПунктаМаршрута = Неопределено;
		Если НЕ РежимРаботыФормыКопия.Свойство("ВидПунктаМаршрута", ВидПунктаМаршрута) Тогда
			ВидПунктаМаршрута = Новый Структура;
		КонецЕсли;
		ВидПунктаМаршрута.Вставить("ТолькоПросмотр", Истина);
		РежимРаботыФормыКопия.Вставить("ВидПунктаМаршрута", ВидПунктаМаршрута);
		
	КонецЕсли;
	
	ПараметрыФормы = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхПунктаМаршрута();
	ПараметрыФормы.Вставить("ТолькоПросмотр",   ТолькоПросмотр);
	ПараметрыФормы.Вставить("РежимРаботыФормы", РежимРаботыФормыКопия);
	ПараметрыФормы.Вставить("УказываетсяТранспортноеСредствоПредприятия", УказываетсяТранспортноеСредствоПредприятия);
	ПараметрыФормы.Вставить("ХозяйствующийСубъект", ХозяйствующийСубъект);
	Если ОбязательностьНомераТранспортногоСредства = Истина Тогда
		ПараметрыФормы.Вставить("ОбязательностьНомераТранспортногоСредства", ТекущаяСтрока<>Неопределено И ТекущаяСтрока.НомерСтроки = 1);
	ИначеЕсли ОбязательностьНомераТранспортногоСредства = Ложь Тогда 
		ПараметрыФормы.Вставить("ОбязательностьНомераТранспортногоСредства", Ложь);
	КонецЕсли;
	ПараметрыФормы.Вставить("ЭтоМаршрутВозврата", ЭтаФорма.ЭтоМаршрутВозврата);
	
	ДополнительныеПараметры = Новый Структура;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		ДополнительныеПараметры.Вставить("ТекущаяСтрока", ТекущаяСтрока);
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ТекущаяСтрока);
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуРедактированияПунктаМаршрутаЗавершение",
		ЭтаФорма,
		ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ПунктМаршрутаВЕТИС",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияПунктаМаршрутаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Неопределено;
	Если НЕ ДополнительныеПараметры.Свойство("ТекущаяСтрока", ТекущаяСтрока) Тогда
		ТекущаяСтрока = Маршрут.Добавить();
	КонецЕсли;
	
	ИзмененыПараметрыРегионализации = Ложь;
	Если ТекущаяСтрока.Предприятие <> РезультатЗакрытия.Предприятие
	 ИЛИ ТекущаяСтрока.Адрес <> РезультатЗакрытия.Адрес
	 ИЛИ ТекущаяСтрока.ТипТранспорта <> РезультатЗакрытия.ТипТранспорта
	 ИЛИ ТекущаяСтрока.НомерТранспортногоСредства <> РезультатЗакрытия.НомерТранспортногоСредства Тогда
		ИзмененыПараметрыРегионализации = Истина;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, РезультатЗакрытия);
	СформироватьПредставлениеДанныхПунктаМаршрута(ТекущаяСтрока);
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Маршрут");
	
	Если УказываетсяРегионализация Тогда
		ТекущаяСтрока.ИндексКартинкиРегионализации = ИндексКартинкиРегионализации(
			ТекущаяСтрока.РезультатПроверкиПравилРегионализации,
			ТекущаяСтрока.УсловияРегионализацииВыполнены);
		
		Если ИзмененыПараметрыРегионализации
		   И НЕ РегионализацияКПроверке Тогда
			УстановкаРегионализацииКПроверкеСервер();
		КонецЕсли;
	КонецЕсли;
	
	СформироватьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРегионализации(НомерСтроки)
	
	ПараметрыОткрываемойФормы = Новый Структура;
	ПараметрыОткрываемойФормы.Вставить("Документ", ВладелецСсылка);
	ПараметрыОткрываемойФормы.Вставить("АдресХраненияУсловияРегионализации", АдресВоВременномХранилищеРегионализация);
	ПараметрыОткрываемойФормы.Вставить("НомерУчасткаМаршрута", НомерСтроки);
	ПараметрыОткрываемойФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ДополнительныеПараметры = Новый Структура("НомерУчасткаМаршрута", НомерСтроки);
	
	ОткрытьФорму("Обработка.УсловияРегионализацииВЕТИС.Форма.УсловияРегионализации",
		ПараметрыОткрываемойФормы,
		ЭтотОбъект,
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("ОбработкаИзмененияУсловийРегионализации", ЭтотОбъект, ДополнительныеПараметры),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаИзмененияУсловийРегионализации(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПараметрыРегионализацииСервер(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПараметрыРегионализацииСервер(Результат)
	
	Модифицированность = Истина;
	
	Изменения = ПолучитьИзВременногоХранилища(Результат.РезультатАдрес);
	
	АдресВоВременномХранилищеРегионализация = ПоместитьВоВременноеХранилище(Изменения.Регионализация, АдресВоВременномХранилищеРегионализация);
	
	Товары = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеТовары);
	
	Для каждого СтрокаТЧ Из Товары Цикл
		Если СтрокаТЧ.РезультатПроверкиПравилРегионализации = Перечисления.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешеноПриВыполненииУсловий Тогда
			СтрокаТЧ.УсловияРегионализацииВыполнены = Изменения.ВыполнениеУсловийПоВидамПродукции.Получить(СтрокаТЧ[ИмяПоляВидПродукции]);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаТЧ Из Маршрут Цикл
		Если СтрокаТЧ.РезультатПроверкиПравилРегионализации = Перечисления.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешеноПриВыполненииУсловий Тогда
			СтрокаТЧ.УсловияРегионализацииВыполнены = Изменения.ВыполнениеУсловийПоНомерамМаршрутов.Получить(СтрокаТЧ.НомерСтроки);
			СтрокаТЧ.ИндексКартинкиРегионализации = ИндексКартинкиРегионализации(
				СтрокаТЧ.РезультатПроверкиПравилРегионализации,
				СтрокаТЧ.УсловияРегионализацииВыполнены);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьПредставлениеДанныхПунктаМаршрута(Строка)
	
	Строка.ПунктМаршрутаСтрокой = 
		?(ПустаяСтрока(Строка.АдресПредставление), Строка.Предприятие, Строка.АдресПредставление);
		
	Строка.ДанныеТранспортаСтрокой = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеДанныхТранспортногоСредства(Строка, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИндексКартинкиРегионализации(РезультатПроверкиПравилРегионализации, УсловияРегионализацииВыполнены)
	
	Если РезультатПроверкиПравилРегионализации = ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешено") Тогда
		ИндексКартинки = 0;
	ИначеЕсли РезультатПроверкиПравилРегионализации = ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПеремещениеЗапрещено") Тогда
		ИндексКартинки = 2;
	ИначеЕсли РезультатПроверкиПравилРегионализации = ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешеноПриВыполненииУсловий")
		И УсловияРегионализацииВыполнены Тогда
		ИндексКартинки = 0;
	ИначеЕсли РезультатПроверкиПравилРегионализации = ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПеремещениеРазрешеноПриВыполненииУсловий")
		И НЕ УсловияРегионализацииВыполнены Тогда
		ИндексКартинки = 1;
	Иначе
		ИндексКартинки = 3;
	КонецЕсли;
	
	Возврат ИндексКартинки;
КонецФункции

&НаСервере
Процедура УстановкаРегионализацииКПроверкеСервер()
	
	Для каждого СтрокаТЧ Из Маршрут Цикл
	
		СтрокаТЧ.РезультатПроверкиПравилРегионализации =
			ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПустаяСсылка");
		СтрокаТЧ.УсловияРегионализацииВыполнены = Ложь;
		СтрокаТЧ.ИндексКартинкиРегионализации = ИндексКартинкиРегионализации(
			СтрокаТЧ.РезультатПроверкиПравилРегионализации,
			СтрокаТЧ.УсловияРегионализацииВыполнены);
	
	КонецЦикла;
	
	Товары = ПолучитьИзВременногоХранилища(АдресВоВременномХранилищеТовары);
	Для каждого СтрокаТЧ Из Товары Цикл
	
		СтрокаТЧ.РезультатПроверкиПравилРегионализации =
			ПредопределенноеЗначение("Перечисление.РезультатыПроверкиПравилРегионализации.ПустаяСсылка");
		СтрокаТЧ.УсловияРегионализацииВыполнены = Ложь;
	
	КонецЦикла;
	
	АдресВоВременномХранилищеТовары = ПоместитьВоВременноеХранилище(Товары, АдресВоВременномХранилищеТовары);
	
	РегионализацияКПроверке = Истина;
	
КонецПроцедуры

#КонецОбласти
