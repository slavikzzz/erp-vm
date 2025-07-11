#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Установка отборов.
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);

	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("ПериодРегистрации", ПериодРегистрации);
	КонецЕсли;
	
	ПредставлениеПериодаРегистрации = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации);

	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьСписокТемЭтапов();

	УстановитьОтборВСпискеИсследованийКОтнесениюРасходов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацииПриИзменении(Элемент)

	ОбновитьСписокТемЭтаповКЗавершениюНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПереключательТемыКОформлениюПриИзменении(Элемент)
	
	УстановитьОтборВСпискеИсследованийКОтнесениюРасходов();

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы 	   = Новый Структура("Значение, РежимВыбораПериода", ПериодРегистрации, "МЕСЯЦ");
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,
		,
		, 
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(
		Направление,
		СтандартнаяОбработка,
		ПериодРегистрации,
		ПредставлениеПериодаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписокТемЭтаповКОтнесениюРасходов

&НаКлиенте
Процедура СписокТемЭтаповКОтнесениюРасходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле = Элементы.СписокТемЭтаповКОтнесениюРасходовТемаЭтапИсследований
			ИЛИ Поле = Элементы.СписокТемЭтаповКОтнесениюРасходовДатаЗавершения
			ИЛИ Поле = Элементы.СписокТемЭтаповКОтнесениюРасходовЗавершен Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьОбъект(Элемент.ТекущиеДанные.ТемаЭтап, СтандартнаяОбработка);
	ИначеЕсли Поле = Элементы.СписокТемЭтаповКОтнесениюРасходовДокументЗавершения Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьОбъект(Элемент.ТекущиеДанные.ДокументЗавершения, СтандартнаяОбработка);
	ИначеЕсли Поле = Элементы.СписокТемЭтаповКОтнесениюРасходовОрганизация Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьОбъект(Элемент.ТекущиеДанные.Организация, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСписокТемЭтаповКЗавершению(Команда)

	ОбновитьСписокТемЭтапов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДлительныеОперации

&НаКлиенте
Процедура ОбновитьСписокТемЭтапов()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяСобытия", "ОбновитьСписокТемЭтаповКЗавершению");
		
	ДлительнаяОперация = ОбновитьСписокТемЭтаповКЗавершениюНаСервере();
	
	ОтображениеСостоянияДлительнойОперации(ЭтаФорма, Истина);
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОбновленияСпискаТемЭтаповКЗавершению", ЭтотОбъект, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьСписокТемЭтаповКЗавершениюНаСервере()

	СписокТемЭтаповКОтнесениюРасходов.Очистить();
	
	ПараметрыЗаполнения = Документы.ПризнаниеРасходовПоИсследованиямИРазработкам.ПараметрыЗаполнения();
	ПараметрыЗаполнения.НачалоПериода = ПериодРегистрации;
	ПараметрыЗаполнения.КонецПериода = КонецМесяца(ПериодРегистрации);
	ПараметрыЗаполнения.Организация = Организация;
	ПараметрыЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗавершениеЭтаповИсследованийИРазработок;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление списка тем и этапов к завершению';
															|en = 'Updating list of topics and stages for completion'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ПризнаниеРасходовПоИсследованиямИРазработкам.ТемыЭтапыКОтнесениюРасходов",
		ПараметрыЗаполнения, ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;

КонецФункции

&НаКлиенте
Процедура ПослеОбновленияСпискаТемЭтаповКЗавершению(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ОтображениеСостоянияДлительнойОперации(ЭтаФорма, Ложь);
			ТекстСообщения = НСтр("ru = 'Произошла ошибка обновления списка:';
									|en = 'Error when updating list:'") + Символы.ПС + Результат.КраткоеПредставлениеОшибки;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ЗагрузитьПодготовленныеДанные(Результат.АдресРезультата, ДополнительныеПараметры);
		ОтображениеСостоянияДлительнойОперации(ЭтаФорма, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтображениеСостоянияДлительнойОперации(Форма, ВыполнениеОперации)
	
	Элементы = Форма.Элементы;

	Элементы.ГруппаОтборы.Доступность = НЕ ВыполнениеОперации;
	Элементы.ГруппаВыполнениеРасчетаВФоне.Видимость = ВыполнениеОперации;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(АдресРезультата, ДополнительныеПараметры)
	
	Данные = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Для Каждого Строка Из Данные Цикл
		СтрокаТаблицы = СписокТемЭтаповКОтнесениюРасходов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Строка);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОткрытьОбъект(Ссылка, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПоказатьЗначение(Неопределено, Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументЗавершения(Команда)

	ОчиститьСообщения();

	СписокКОформлению = Элементы.СписокТемЭтаповКОтнесениюРасходов;
	ТекущаяСтрокаКОформлению = СписокКОформлению.ТекущиеДанные;
	
	Если ТекущаяСтрокаКОформлению = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта.';
									|en = 'Cannot execute the command for the object.'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ТекущаяОрганизация = ТекущаяСтрокаКОформлению.Организация;

	ТемыЭтапыКЗавершению = Новый Массив();

	Для Каждого ТекущаяСтрокаКОформлению Из СписокКОформлению.ВыделенныеСтроки Цикл

		ТекущиеДанныеПоСтроке = СписокКОформлению.ДанныеСтроки(ТекущаяСтрокаКОформлению);
		Если ТекущиеДанныеПоСтроке.Организация = ТекущаяОрганизация Тогда
			Если ТекущиеДанныеПоСтроке.ДокументЗавершения.Пустая() Тогда
				ТемыЭтапыКЗавершению.Добавить(ТекущиеДанныеПоСтроке.ТемаЭтап);
			Иначе
				ТекстСообщения = НСтр("ru = 'Для %1 уже введен документ завершения. Элемент не может быть включен в состав нового документа';
										|en = 'The completion document has already been entered for %1. The item cannot be included in the new document'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(ТекстСообщения, ТекущиеДанныеПоСтроке.ТемаЭтап),,
					"СписокТемЭтаповКОтнесениюРасходов[" + СписокТемЭтаповКОтнесениюРасходов.Индекс(ТекущаяСтрокаКОформлению) + "].ТемаЭтап");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Если ТемыЭтапыКЗавершению.Количество() > 0 Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ТемыЭтапы", ТемыЭтапыКЗавершению);
		ЗначенияЗаполнения.Вставить("Организация", ТекущаяОрганизация);
		ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗавершениеЭтаповИсследованийИРазработок"));

		ОткрытьФорму("Документ.ПризнаниеРасходовПоИсследованиямИРазработкам.Форма.ФормаДокумента", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), , Истина, , , Новый ОписаниеОповещения("СформироватьДокументЗавершенияЗавершение", ЭтотОбъект));
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена, так как нет доступных тем к завершению.';
									|en = 'Cannot execute command because there are no topics available for completion.'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументЗавершенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьСписокТемЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокТемЭтаповКОтнесениюРасходов()
	
	ОбновитьСписокТемЭтаповКЗавершениюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВСпискеИсследованийКОтнесениюРасходов()
	
	Если ПереключательТемыКОформлению = 0 Тогда
		Элементы.СписокТемЭтаповКОтнесениюРасходов.ОтборСтрок = Новый ФиксированнаяСтруктура("ДокументЗавершенияСформирован", Ложь);
	Иначе
		Элементы.СписокТемЭтаповКОтнесениюРасходов.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		
		ПериодРегистрации = ВыбранныйПериод;
		ПредставлениеПериодаРегистрации =
			ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ПериодРегистрации);
		
	КонецЕсли;
	
	ОбновитьСписокТемЭтаповКОтнесениюРасходов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокТемЭтаповКОтнесениюРасходов.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокТемЭтаповКОтнесениюРасходов.ДокументЗавершенияСформирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

#КонецОбласти




