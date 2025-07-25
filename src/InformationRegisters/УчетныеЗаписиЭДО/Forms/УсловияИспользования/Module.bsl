
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтаФорма);
	
	Если Параметры.Свойство("ОзнакомитьСПрекращениемПоддержкиПрямогоОбмена") Тогда
		СписокЭтапов.Добавить(ЭтапИнформацияОПрекращенииПрямогоОбмена());
	КонецЕсли;
	
	УчетныеЗаписи = Неопределено;
	Если Параметры.Свойство("УчетныеЗаписиЭДО", УчетныеЗаписи) Тогда
		СписокЭтапов.Добавить(ЭтапУсловияИспользования());
		СписокЭтапов.Добавить(ЭтапИнформацияДляКонтрагентов());
		ЗаполнитьИнформациюДляКонтрагентов(УчетныеЗаписи);
	КонецЕсли;
	
	Если СписокЭтапов.Количество() = 0 Тогда
		СписокЭтапов.Добавить(ЭтапУсловияИспользования());
		Элементы.ПринятыУсловияИспользования.Видимость = Ложь;
	КонецЕсли;
	
	Если СписокЭтапов.Количество() = 1 Тогда
		Элементы.КомандаГотово.Заголовок = НСтр("ru = 'Закрыть';
												|en = 'Close'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть") Тогда
		Элементы.НадписьОбменЧерезБизнесСеть.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если МобильныйКлиент Тогда
		Закрыть(Истина);
	#Иначе
		ИнициализироватьТекущийЭтап();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	КлючСохраненияПоложенияОкна = "";
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПринятыУсловияИспользованияПриИзменении(Элемент)
	
	Элементы.КомандаДалее.Доступность = ПринятыУсловияИспользования;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеУчетнойЗаписиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИдентификаторЭДО = ИнформацияДляКонтрагентов[0].ИдентификаторЭДО;
	ОткрытьФормуУчетнойЗаписиЭДО(ИдентификаторЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОбменЧерезОператораЭДООбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ЭДО" Тогда
		СтандартнаяОбработка = Ложь;
		СинхронизацияЭДОКлиент.ОткрытьСайтСервиса1СЭДО();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОбменЧерезБизнесСетьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "БизнесСеть" Тогда
		СтандартнаяОбработка = Ложь;
		СинхронизацияЭДОКлиент.ОткрытьСайтСервисаБизнесСеть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнформацияДляКонтрагентов

&НаКлиенте
Процедура ИнформацияДляКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ИнформацияДляКонтрагентовНаименованиеУчетнойЗаписи" Тогда
		ИдентификаторЭДО = ИнформацияДляКонтрагентов.НайтиПоИдентификатору(ВыбраннаяСтрока).ИдентификаторЭДО;
		ОткрытьФормуУчетнойЗаписиЭДО(ИдентификаторЭДО);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияДляКонтрагентовПриАктивизацииСтроки(Элемент)
	
	Для каждого СтрокаИнформации Из ИнформацияДляКонтрагентов Цикл
		Если СтрокаИнформации.ЭтоАктивнаяСтрока Тогда
			СтрокаИнформации.ЭтоАктивнаяСтрока = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элемент.ТекущиеДанные.ЭтоАктивнаяСтрока = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ПерейтиКСледующемуЭтапу();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ПерейтиКСледующемуЭтапу();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ИндексЭтапа = ИндексЭтапа - 1;
	ИнициализироватьТекущийЭтап();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияДляКонтрагентовНазначениеУчетнойЗаписи.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ЭтоАктивнаяСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.НазначениеУчетнойЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Например, ""Для документов от поставщиков""';
																|en = 'For example, ""For documents from suppliers.""'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.МелкийШрифтТекста);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияДляКонтрагентовПодробноеОписаниеУчетнойЗаписи.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ЭтоАктивнаяСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияДляКонтрагентов.ПодробноеОписаниеУчетнойЗаписи");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Например, можно указать контакты ответственных сотрудников';
																|en = 'For example, you can specify contacts of responsible employees'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.МелкийШрифтТекста);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуУчетнойЗаписиЭДО(ИдентификаторЭДО);
	
	УчетныеЗаписиЭДОСлужебныйКлиент.ОткрытьУчетнуюЗапись(ИдентификаторЭДО);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьТекущийЭтап()
	
	ТекущийЭтап = СписокЭтапов[ИндексЭтапа].Значение;
	Если ТекущийЭтап = ЭтапУсловияИспользования() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаУсловияИспользования;
		Если Элементы.ПринятыУсловияИспользования.Видимость Тогда
			Элементы.КомандаДалее.Доступность = ПринятыУсловияИспользования;
		КонецЕсли;
		Заголовок = НСтр("ru = 'Использование сервиса';
						|en = 'Use of service'");
		
	ИначеЕсли ТекущийЭтап = ЭтапИнформацияДляКонтрагентов() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаИнформацияДляКонтрагентов;
		Элементы.КомандаДалее.Доступность = Истина;
		Заголовок = НСтр("ru = 'Использование сервиса';
						|en = 'Use of service'");
		
	ИначеЕсли ТекущийЭтап = ЭтапИнформацияОПрекращенииПрямогоОбмена() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаИнформацияОПрекращенииПрямогоОбмена;
		Элементы.КомандаДалее.Доступность = Истина;
		Заголовок = НСтр("ru = 'Прекращение поддержки прямого обмена';
						|en = 'Stop direct exchange support'");
		
	КонецЕсли;
	
	НастроитьКомандыПереходаПоЭтапам();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьКомандыПереходаПоЭтапам()
	
	КоличествоЭтапов = СписокЭтапов.Количество();
	Если КоличествоЭтапов = 1 Тогда
		Элементы.КомандаНазад.Видимость = Ложь;
		Элементы.КомандаДалее.Видимость = Ложь;
		Элементы.КомандаГотово.Видимость = Истина;
		
		Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ИндексЭтапа = 0 Тогда
		Элементы.КомандаНазад.Видимость = Ложь;
		Элементы.КомандаДалее.Видимость = Истина;
		Элементы.КомандаГотово.Видимость = Ложь;
		
		Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ИндексЭтапа = КоличествоЭтапов - 1 Тогда
		Элементы.КомандаНазад.Видимость = Истина;
		Элементы.КомандаДалее.Видимость = Ложь;
		Элементы.КомандаГотово.Видимость = Истина;
		
		Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
		
	Иначе
		Элементы.КомандаНазад.Видимость = Истина;
		Элементы.КомандаДалее.Видимость = Истина;
		Элементы.КомандаГотово.Видимость = Ложь;
		
		Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуЭтапу(ОбработкаЭтапа = Истина)
	
	Если ОбработкаЭтапа Тогда
		
		Отказ = Ложь;
		ВыполнитьТекущийЭтап(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ИндексЭтапа = ИндексЭтапа + 1;
	
	Если ИндексЭтапа = СписокЭтапов.Количество() Тогда
		ЗавершитьОбработку();
	Иначе
		ИнициализироватьТекущийЭтап();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТекущийЭтап(Отказ)
	
	ТекущийЭтап = СписокЭтапов[ИндексЭтапа].Значение;
	Если ТекущийЭтап = ЭтапИнформацияДляКонтрагентов() Тогда
		ПроверитьИнформациюДляКонтрагентов(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИнформациюДляКонтрагентов(Отказ)
	
	Для Каждого СтрокаИнформации Из ИнформацияДляКонтрагентов Цикл
		Если Не (ЗначениеЗаполнено(СтрокаИнформации.НазначениеУчетнойЗаписи)
			И ЗначениеЗаполнено(СтрокаИнформации.ПодробноеОписаниеУчетнойЗаписи)) Тогда
			Отказ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбработкаОтвета = Новый ОписаниеОповещения("ПерейтиДалееПослеВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Не заполнена информация для контрагентов. Продолжить без заполнения?';
						|en = 'Information for counterparties is not filled in. Continue without filling in?'");
	ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиДалееПослеВопроса(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПерейтиКСледующемуЭтапу(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтапУсловияИспользования()
	Возврат "УсловияИспользования";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтапИнформацияДляКонтрагентов()
	Возврат "ИнформацияДляКонтрагентов";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтапИнформацияОПрекращенииПрямогоОбмена()
	Возврат "ИнформацияОПрекращенииПрямогоОбмена";
КонецФункции

&НаСервере
Процедура ЗаполнитьИнформациюДляКонтрагентов(ИдентификаторыЭДО)
	
	СвойстваУчетныхЗаписей = УчетныеЗаписиЭДОСлужебный.СвойстваУчетныхЗаписей(ИдентификаторыЭДО);
	
	Для Каждого УчетнаяЗапись Из СвойстваУчетныхЗаписей Цикл
		ЗаполнитьЗначенияСвойств(ИнформацияДляКонтрагентов.Добавить(), УчетнаяЗапись.Значение);
	КонецЦикла;
	
	МассивСтрок = Новый Массив;
	Если ИнформацияДляКонтрагентов.Количество() = 1 Тогда
		Элементы.ПанельИнформацияДляКонтрагентов.ТекущаяСтраница = Элементы.СтраницаИнформацияДляКонтрагентовСтрока;
		Элементы.СтраницаИнформацияДляКонтрагентовТаблица.Видимость = Ложь;
		МассивСтрок.Добавить(НСтр("ru = 'Заполните сведения о своей учетной записи.';
									|en = 'Fill in your account information.'"));
	Иначе
		Элементы.ПанельИнформацияДляКонтрагентов.ТекущаяСтраница = Элементы.СтраницаИнформацияДляКонтрагентовТаблица;
		Элементы.СтраницаИнформацияДляКонтрагентовСтрока.Видимость = Ложь;
		МассивСтрок.Добавить(НСтр("ru = 'Заполните сведения о своей учетной записи.';
									|en = 'Fill in your account information.'"));
	КонецЕсли;
	
	МассивСтрок.Добавить(НСтр("ru = 'Это позволит контрагентам получать информацию о ваших требованиях к электронному документообороту в любой удобный момент.';
								|en = 'This will allow counterparties to receive information about your requirements for electronic document flow at any convenient time.'"));
	
	Элементы.НадписьИнформацияДляКонтрагентов.Заголовок = СтрСоединить(МассивСтрок, " ");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработку()
	
	ЗавершитьОбработкуНаСервере();
	
	Если СписокЭтапов.НайтиПоЗначению(ЭтапИнформацияДляКонтрагентов()) <> Неопределено Тогда
		Результат = ПринятыУсловияИспользования;
	Иначе
		Результат = Истина;
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьОбработкуНаСервере()
	
	Если СписокЭтапов.НайтиПоЗначению(ЭтапИнформацияДляКонтрагентов()) <> Неопределено Тогда
		ЗаписатьДанныеУчетныхЗаписейЭДО();
	КонецЕсли;
	
	Если СписокЭтапов.НайтиПоЗначению(ЭтапИнформацияОПрекращенииПрямогоОбмена()) <> Неопределено Тогда
		СинхронизацияЭДО.ОзнакомитьсяСПрекращениемПоддержкиПрямогоОбмена();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеУчетныхЗаписейЭДО()
	
	Для Каждого СтрокаТаблицы Из ИнформацияДляКонтрагентов Цикл
		
		ДанныеУчетнойЗаписи = Новый Структура;
		ДанныеУчетнойЗаписи.Вставить("Назначение", СтрокаТаблицы.НазначениеУчетнойЗаписи);
		ДанныеУчетнойЗаписи.Вставить("ПодробноеОписание", СтрокаТаблицы.ПодробноеОписаниеУчетнойЗаписи);
		УчетныеЗаписиЭДОСлужебный.ИзменитьДанныеУчетнойЗаписи(СтрокаТаблицы.ИдентификаторЭДО, ДанныеУчетнойЗаписи);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

