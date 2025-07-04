#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если ПроведениеДокументов.СвойстваДокумента(ЭтотОбъект).ЭтоНовый Тогда
		ПолучитьСсылкуНового();
	КонецЕсли;
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
		Для Каждого Строка Из Списание Цикл
			Строка.НаправлениеДеятельности = НаправлениеДеятельности;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаСписания Из Списание Цикл
		
		Если ЗначениеЗаполнено(СтрокаСписания.Подразделение) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаСписания.Подразделение = Подразделение;
		
	КонецЦикла;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Списание");
	
	ВсегоДолейСтоимости = ДоляСтоимостиНаПроизводство + ДоляСтоимостиНаНЗП + ДоляСтоимостиНаСтатьи + ДоляСтоимостиНаОВЗ;
		
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И (НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее
			Или НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Вышестоящее
			Или НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Нижестоящие) Тогда
		
		СхемаКД = Справочники.ПравилаРаспределенияРасходов.ПолучитьМакет("НаправлениеРаспределения");
		НастройкиПоУмолчанию = СхемаКД.НастройкиПоУмолчанию;
			
		ОтборПоПодразделению = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
			Тип("ЭлементОтбораКомпоновкиДанных"));
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее Тогда
			
			ОтборПоПодразделению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				
		ИначеЕсли НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Вышестоящее Тогда
			
			ОтборПоПодразделению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ВышестоящееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				
		ИначеЕсли НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Нижестоящие Тогда
			
			ОтборПоПодразделению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
			ОтборПоПодразделению.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
			ОтборПоПодразделению.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			
			ОтборПоПодразделениюНеРавно = НастройкиПоУмолчанию.Отбор.Элементы.Добавить(
				Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоПодразделениюНеРавно.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
			ОтборПоПодразделениюНеРавно.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
			ОтборПоПодразделениюНеРавно.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ПараметрыДанных.ТекущееПодразделение");
		
		КонецЕсли;

		НастройкиНаправленияРаспределенияИзменены = Истина;
		НастройкиНаправленияРаспределения = Новый ХранилищеЗначения(НастройкиПоУмолчанию);
		
	КонецЕсли;
		
	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.РаспределениеПрочихЗатрат.ПараметрыНастройкиСчетовУчета());
		
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, 
		Документы.РаспределениеПрочихЗатрат.ПараметрыВыбораСтатейИАналитик());
	//-- НЕ УТ
	
	Если НазначениеНастройкиРаспределения <> Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		ИсточникДанных = Перечисления.ИсточникиДанныхДляРаспределенияРасходов.ПустаяСсылка();
	КонецЕсли;
	
	// Проверка на некорректные настройки правил распределения в разрезе организаций и подразделений
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЕстьОшибкиНазначения = Ложь;
		ВариантыСтатьи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			?(ЗначениеЗаполнено(СтатьяРасходов), СтатьяРасходов, АналитикаРасходов), 
			"ВариантРаспределенияРасходовУпр, ВариантРаспределенияРасходовРегл");
		Если УправленческийУчет И НазначениеНастройкиРаспределения <> 
			Справочники.ПравилаРаспределенияРасходов.ПолучитьНазначениеПравилаПоВариантуРаспределения(ВариантыСтатьи.ВариантРаспределенияРасходовУпр) 
		Тогда
			ЕстьОшибкиНазначения = Истина;
		КонецЕсли;
		Если РегламентированныйУчет И НазначениеНастройкиРаспределения <> 
			Справочники.ПравилаРаспределенияРасходов.ПолучитьНазначениеПравилаПоВариантуРаспределения(ВариантыСтатьи.ВариантРаспределенияРасходовРегл) 
		Тогда
			ЕстьОшибкиНазначения = Истина;
		КонецЕсли;
		Если ЕстьОшибкиНазначения Тогда
			ТекстСообщения = НСтр("ru = 'При формировании документа распределения расходов обнаружено расхождение варианта и правила распределения в статье расходов.
				|Необходимо привести в соответствие настройки правил в разрезе организаций и подразделений.
				|Период: %1, организация: ""%2"", подразделение: ""%3"", статья расходов: ""%4""';
				|en = 'Discrepancy of the option and the allocation rule is detected in the expense item upon generating the expense allocation document.
				|Match the rule settings by companies and business units.
				|Period: %1, company: ""%2"", business unit: ""%3"", expense item: ""%4""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Формат(Дата, "ДФ='ММММ гггг';"), Организация, Подразделение, СтатьяРасходов);
			
			Отказ = Истина;
			ВызватьИсключение ТекстСообщения;
				
		КонецЕсли;
	КонецЕсли;
	
	РаспределениеПрочихЗатратЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Списание");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	РаспределениеПрочихЗатратЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЭтоРаспределениеИзОВЗ = ЛОЖЬ;
	ЭтоРаспределениеНаОВЗ = ЛОЖЬ;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		КлючПравилаРаспределения = "";
		КлючВариантаРаспределения = "";
		Если УправленческийУчет Тогда
			КлючПравилаРаспределения = "ПравилоРаспределенияУпр";
			КлючВариантаРаспределения = "ВариантРаспределенияУпр";
		ИначеЕсли РегламентированныйУчет Тогда
			КлючПравилаРаспределения = "ПравилоРаспределенияРегл";
			КлючВариантаРаспределения = "ВариантРаспределенияРегл";
		//++ НЕ УТ

		//++ Локализация
		ИначеЕсли НалоговыйУчет Тогда
			КлючПравилаРаспределения = "ПравилоРаспределенияНал";
			КлючВариантаРаспределения = "ВариантРаспределенияНал";
		//-- Локализация

		//-- НЕ УТ
		ИначеЕсли НДД Тогда
			КлючПравилаРаспределения = "ПравилоРаспределенияНДД";
			КлючВариантаРаспределения = "ВариантРаспределенияНДД";
		КонецЕсли;
			
		//++ НЕ УТ
		ЭтоРаспределениеИзОВЗ = 
			ТипЗнч(АналитикаРасходов) = Тип("СправочникСсылка.ОбъектыВозникновенияЗатрат");
		ЭтоРаспределениеНаОВЗ = 
			ДанныеЗаполнения[КлючВариантаРаспределения] = Перечисления.ВариантыРаспределенияРасходов.НаОбъектыВозникновенияЗатрат;
		//-- НЕ УТ
		
		Если ДанныеЗаполнения.Свойство(КлючВариантаРаспределения)
			И ЗначениеЗаполнено(ДанныеЗаполнения[КлючВариантаРаспределения])
			И Перечисления.ВариантыРаспределенияРасходов.ВариантИспользуетПравилоРаспределения(ДанныеЗаполнения[КлючВариантаРаспределения])
			И ДанныеЗаполнения.Свойство(КлючПравилаРаспределения)
			И ЗначениеЗаполнено(ДанныеЗаполнения[КлючПравилаРаспределения]) Тогда
			//++ НЕ УТ
			Если ТипЗнч(ДанныеЗаполнения[КлючПравилаРаспределения]) = Тип("СправочникСсылка.ПравилаРаспределенияРасходов") Тогда
			//-- НЕ УТ
				
				ТекстЗапроса = 
					"ВЫБРАТЬ
					|	ПравилаРаспределения.НазначениеПравила КАК НазначениеНастройкиРаспределения,
					|	ПравилаРаспределения.НаправлениеРаспределения КАК НаправлениеРаспределения,
					|	ПравилаРаспределения.БазаРаспределенияПоПартиям КАК БазаРаспределенияПоПартиям,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиямИзменены,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиям,
					|	ВЫБОР
					|		КОГДА ПравилаРаспределения.ИсточникДанных = ЗНАЧЕНИЕ(Перечисление.ИсточникиДанныхДляРаспределенияРасходов.ПустаяСсылка)
					|			И ПравилаРаспределения.НазначениеПравила = ЗНАЧЕНИЕ(Перечисление.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат)
					|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ИсточникиДанныхДляРаспределенияРасходов.ФинансовыеРезультаты)
					|		ИНАЧЕ ПравилаРаспределения.ИсточникДанных
					|	КОНЕЦ КАК ИсточникДанных,
					//++ НЕ УТ
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиямИзменены,
					|	ПравилаРаспределения.НастройкиНаправленияРаспределенияИзменены,
					|	ПравилаРаспределения.РаспределятьПоПартиям КАК РаспределятьПоПартиям,
					|	ПравилаРаспределения.РаспределятьНаСтатьи КАК РаспределятьНаСтатьи,
					|	ПравилаРаспределения.БазаРаспределенияПоПодразделениям КАК БазаРаспределенияПоПодразделениям,
					|	ПравилаРаспределения.УточнятьПартииВДокументе КАК ПартииУказаныВручную,
					|	ПравилаРаспределения.ДоляСтоимостиНаПроизводство КАК ДоляСтоимостиНаПроизводство,
					|	ПравилаРаспределения.ДоляСтоимостиНаСтатьи КАК ДоляСтоимостиНаСтатьи,
					|	ПравилаРаспределения.Показатель КАК Показатель,
					|	ПравилаРаспределения.РаспределятьПоПодразделениям КАК РаспределятьПоПодразделениям,
					|	ПравилаРаспределения.ПодразделенияУказаныВручную КАК ПодразделенияУказаныВручную,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиям,
					|	ПравилаРаспределения.НастройкиНаправленияРаспределения,
					//++ Локализация
					|	ПравилаРаспределения.ОтборПоПодразделениям.(
					|		Подразделение КАК Подразделение
					|	) КАК ОтборПоПодразделениям,
					|	ПравилаРаспределения.ОтборПоМатериалам.(
					|		Материал КАК Материал
					|	) КАК ОтборПоМатериалам,
					|	ПравилаРаспределения.ОтборПоВидамРабот.(
					|		ВидРабот КАК ВидРабот
					|	) КАК ОтборПоВидамРабот,
					|	ПравилаРаспределения.ОтборПоГруппамПродукции.(
					|		ГруппаПродукции КАК ГруппаПродукции
					|	) КАК ОтборПоГруппамПродукции,
					|	ПравилаРаспределения.ОтборПоПродукции.(
					|		Продукция КАК Продукция
					|	) КАК ОтборПоПродукции,
					//-- Локализация
					|	ПравилаРаспределения.Подразделения.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		Подразделение КАК Подразделение,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК ПоБазе,
					|	ПравилаРаспределения.Списание.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		СтатьяРасходов КАК СтатьяРасходов,
					|		АналитикаРасходов КАК АналитикаРасходов,
					|		ДоляСтоимости КАК ДоляСтоимости,
					|		АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
					|		НастройкаСчетовУчета КАК НастройкаСчетовУчета,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ИдентификаторСтроки КАК ИдентификаторСтроки,
					|		Подразделение КАК Подразделение
					|	) КАК Списание,
					//-- НЕ УТ
					|	ПравилаРаспределения.ОтборПоНаправлениямДеятельности.(
					|		НаправлениеДеятельности КАК НаправлениеДеятельности
					|	) КАК ОтборПоНаправлениямДеятельности,
					|	ПравилаРаспределения.НаправленияДеятельности.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК НаправленияДеятельности
					|ИЗ
					|	Справочник.ПравилаРаспределенияРасходов КАК ПравилаРаспределения
					|ГДЕ
					|	ПравилаРаспределения.Ссылка = &Ссылка";
			//++ НЕ УТ
			Иначе
				
				ТекстЗапроса = 
					"ВЫБРАТЬ
					|	ПравилаРаспределения.НазначениеНастройкиРаспределения КАК НазначениеНастройкиРаспределения,
					|	ПравилаРаспределения.РаспределятьПоПартиям КАК РаспределятьПоПартиям,
					|	ПравилаРаспределения.РаспределятьНаСтатьи КАК РаспределятьНаСтатьи,
					|	ПравилаРаспределения.БазаРаспределенияПоПартиям КАК БазаРаспределенияПоПартиям,
					|	ПравилаРаспределения.БазаРаспределенияПоПодразделениям КАК БазаРаспределенияПоПодразделениям,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиямИзменены,
					|	ПравилаРаспределения.НастройкиНаправленияРаспределенияИзменены,
					|	ПравилаРаспределения.СтатьяКалькуляции КАК СтатьяКалькуляции,
					|	ПравилаРаспределения.НаправлениеРаспределения КАК НаправлениеРаспределения,
					|	ПравилаРаспределения.ПартииУказаныВручную КАК ПартииУказаныВручную,
					|	ПравилаРаспределения.ДоляСтоимостиНаПроизводство КАК ДоляСтоимостиНаПроизводство,
					|	ПравилаРаспределения.ДоляСтоимостиНаСтатьи КАК ДоляСтоимостиНаСтатьи,
					|	ПравилаРаспределения.Показатель КАК Показатель,
					|	ПравилаРаспределения.РаспределятьПоПодразделениям КАК РаспределятьПоПодразделениям,
					|	ПравилаРаспределения.ПодразделенияУказаныВручную КАК ПодразделенияУказаныВручную,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиямИзменены,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиям,
					|	ПравилаРаспределения.НастройкиБазыРаспределенияПоПартиям,
					|	ПравилаРаспределения.НастройкиНаправленияРаспределения,
					|	ПравилаРаспределения.ИсточникДанных,
					//++ Локализация
					|	ПравилаРаспределения.ОтборПоПодразделениям.(
					|		Подразделение КАК Подразделение
					|	) КАК ОтборПоПодразделениям,
					|	ПравилаРаспределения.ОтборПоМатериалам.(
					|		Материал КАК Материал
					|	) КАК ОтборПоМатериалам,
					|	ПравилаРаспределения.ОтборПоВидамРабот.(
					|		ВидРабот КАК ВидРабот
					|	) КАК ОтборПоВидамРабот,
					|	ПравилаРаспределения.ОтборПоГруппамПродукции.(
					|		ГруппаПродукции КАК ГруппаПродукции
					|	) КАК ОтборПоГруппамПродукции,
					|	ПравилаРаспределения.ОтборПоПродукции.(
					|		Продукция КАК Продукция
					|	) КАК ОтборПоПродукции,
					//-- Локализация
					|	ПравилаРаспределения.ОтборПоНаправлениямДеятельности.(
					|		НаправлениеДеятельности КАК НаправлениеДеятельности
					|	) КАК ОтборПоНаправлениямДеятельности,
					|	ПравилаРаспределения.Списание.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		СтатьяРасходов КАК СтатьяРасходов,
					|		АналитикаРасходов КАК АналитикаРасходов,
					|		ДоляСтоимости КАК ДоляСтоимости,
					|		АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
					|		НастройкаСчетовУчета КАК НастройкаСчетовУчета,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ИдентификаторСтроки КАК ИдентификаторСтроки,
					|		Подразделение КАК Подразделение
					|	) КАК Списание,
					|	ПравилаРаспределения.ПоБазе.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		Подразделение КАК Подразделение,
					|		СтатьяКалькуляции КАК СтатьяКалькуляции,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК ПоБазе,
					|	ПравилаРаспределения.НаправленияДеятельности.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК НаправленияДеятельности
					|ИЗ
					|	Документ.РаспределениеПрочихЗатрат КАК ПравилаРаспределения
					|ГДЕ
					|	ПравилаРаспределения.Ссылка = &Ссылка";
				
			КонецЕсли;
			//-- НЕ УТ
			
			Запрос = Новый Запрос;
			Запрос.Текст = ТекстЗапроса;
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения[КлючПравилаРаспределения]);
			//++ НЕ УТ

			//++ Локализация
			УчетПоГруппамПродукции = ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции");
			//-- Локализация

			//-- НЕ УТ
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, , 
					"ОтборПоНаправлениямДеятельности,
					//++ НЕ УТ

					//++ Локализация
					|ОтборПоМатериалам, ОтборПоПодразделениям, ОтборПоВидамРабот, ОтборПоГруппамПродукции, ОтборПоПродукции,
					|Списание, ПоБазе,
					//-- Локализация

					//-- НЕ УТ
					|НаправленияДеятельности");
				
				ВыборкаНастройкиБазыРаспределенияПоПартиям = 
					Выборка.НастройкиБазыРаспределенияПоПартиям; // ХранилищеЗначения
				
				//++ НЕ УТ
				
				ВыборкаНастройкиНаправленияРаспределения = 
					Выборка.НастройкиНаправленияРаспределения; // ХранилищеЗначения
					
				//++ Локализация
				
				Если РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии21(Дата) Тогда
					Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные Тогда
						ОтборПоПодразделениям.Загрузить(Выборка.ОтборПоПодразделениям.Выгрузить());
					Иначе
						ОтборПоПодразделениям.Очистить();
					КонецЕсли;
					
					ОтборПоМатериалам.Загрузить(Выборка.ОтборПоМатериалам.Выгрузить());
					Если УчетПоГруппамПродукции Тогда
						ОтборПоГруппамПродукции.Загрузить(Выборка.ОтборПоГруппамПродукции.Выгрузить());
					КонецЕсли;
					ОтборПоПродукции.Загрузить(Выборка.ОтборПоПродукции.Выгрузить());
					ОтборПоВидамРабот.Загрузить(Выборка.ОтборПоВидамРабот.Выгрузить());
					
				КонецЕсли;
				//-- Локализация
				
				НастройкиБазыРаспределенияПоПартиям = Новый ХранилищеЗначения(
					ВыборкаНастройкиБазыРаспределенияПоПартиям.Получить());
				НастройкиНаправленияРаспределения = Новый ХранилищеЗначения(
					ВыборкаНастройкиНаправленияРаспределения.Получить());
				ДанныеЗаполнения.Вставить("НастройкиБазыРаспределенияПоПартиям",
					ВыборкаНастройкиБазыРаспределенияПоПартиям.Получить());
				ДанныеЗаполнения.Вставить("НастройкиНаправленияРаспределения",
					ВыборкаНастройкиНаправленияРаспределения.Получить());
				Списание.Загрузить(Выборка.Списание.Выгрузить());
				ПоБазе.Загрузить(Выборка.ПоБазе.Выгрузить());
				Для Каждого СтрокаПоБазе Из ПоБазе Цикл
					СтрокаПоБазе.СтатьяКалькуляции = СтатьяКалькуляции;
				КонецЦикла;
				//-- НЕ УТ
				
				НастройкиБазыРаспределенияПоПартиям = Новый ХранилищеЗначения(
					ВыборкаНастройкиБазыРаспределенияПоПартиям.Получить());
				ДанныеЗаполнения.Вставить("НастройкиБазыРаспределенияПоПартиям",
					ВыборкаНастройкиБазыРаспределенияПоПартиям.Получить());
				
				ОтборПоНаправлениямДеятельности.Загрузить(Выборка.ОтборПоНаправлениямДеятельности.Выгрузить());
				НаправленияДеятельности.Загрузить(Выборка.НаправленияДеятельности.Выгрузить());
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НазначениеНастройкиРаспределения) Тогда
		
		НазначенияПоВарианту = Новый Соответствие;
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат);
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьТоваров);
		//++ НЕ УТ	
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства);
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаОбъектыВозникновенияЗатрат,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаОВЗ);
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьПроизводства,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьПроизводства);
		//-- НЕ УТ
		ВариантыРаспределения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(?(ЭтоРаспределениеИзОВЗ, АналитикаРасходов, СтатьяРасходов), 
			"ВариантРаспределенияРасходовУпр,ВариантРаспределенияРасходовРегл
			//++ НЕ УТ

			//++ Локализация
			|,ВариантРаспределенияРасходовНУ
			//-- Локализация

			//-- НЕ УТ
			|");
		
		Если УправленческийУчет Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ВариантыРаспределения.ВариантРаспределенияРасходовУпр);
		ИначеЕсли РегламентированныйУчет Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ВариантыРаспределения.ВариантРаспределенияРасходовРегл);
		//++ НЕ УТ

		//++ Локализация
		ИначеЕсли НалоговыйУчет Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ВариантыРаспределения.ВариантРаспределенияРасходовНУ);
		//-- Локализация	

		//-- НЕ УТ
		ИначеЕсли НДД Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ДанныеЗаполнения.ВариантРаспределенияНДД);
		КонецЕсли;
			
	КонецЕсли;
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		
		Если ЗначениеЗаполнено(НаправлениеДеятельности) Или ТипЗнч(АналитикаРасходов) = Тип("СправочникСсылка.НаправленияДеятельности")
			И ЗначениеЗаполнено(АналитикаРасходов) Или Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
			НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее;
		КонецЕсли;
		
		Если ИсточникДанных.Пустая() Тогда
			ИсточникДанных = Перечисления.ИсточникиДанныхДляРаспределенияРасходов.ВыручкаИСебестоимостьПродаж;
		КонецЕсли;
		
	ИначеЕсли НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаОВЗ
		И ЭтоРаспределениеНаОВЗ И ЗначениеЗаполнено(АналитикаРасходов) Тогда
		ПоказателиРаспределения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АналитикаРасходов, 
			"ПравилоРаспределенияРасходовУпр, ПравилоРаспределенияРасходовРегл
			//++ НЕ УТ

			//++ Локализация
			|,ПравилоРаспределенияРасходовНУ
			//-- Локализация

			//-- НЕ УТ
			|");
		РаспределятьНаОВЗ = Истина;
		Если УправленческийУчет Тогда
			Показатель = ПоказателиРаспределения.ПравилоРаспределенияРасходовУпр;
		ИначеЕсли РегламентированныйУчет Тогда
			Показатель = ПоказателиРаспределения.ПравилоРаспределенияРасходовРегл;
		//++ НЕ УТ

		//++ Локализация
		ИначеЕсли НалоговыйУчет Тогда
			Показатель = ПоказателиРаспределения.ПравилоРаспределенияРасходовНУ;
		//-- Локализация

		//-- НЕ УТ
		ИначеЕсли НДД Тогда
			Показатель = ДанныеЗаполнения.ПравилоРаспределенияНДД;
		КонецЕсли;
	ИначеЕсли НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьПроизводства Тогда
		БазаРаспределенияПоПартиям = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтатьяРасходов, 
			"БазаРаспределенияПоПартиям").БазаРаспределенияПоПартиям;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	//++ НЕ УТ	
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, 
		Документы.РаспределениеПрочихЗатрат.ПараметрыВыбораСтатейИАналитик());
	//-- НЕ УТ	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЭтотОбъект.ДополнительныеСвойства.ПроведениеДокументов.Вставить("НеФормироватьУправленческийБаланс");
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(Дата, Ссылка, Организация);
	КонецЕсли;
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не ((ДополнительныеСвойства.Свойство("ОтменитьЗаписьЗаданияКРасчетуСебестоимости")
				И ДополнительныеСвойства.ОтменитьЗаписьЗаданияКРасчетуСебестоимости) Или
		НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат) Тогда
		
		РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(Дата, Ссылка, Организация);
	КонецЕсли;
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РаспределениеПрочихЗатрат.Ссылка
		|ИЗ
		|	Документ.РаспределениеПрочихЗатрат КАК РаспределениеПрочихЗатрат
		|ГДЕ
		|	РаспределениеПрочихЗатрат.Проведен
		|	И РаспределениеПрочихЗатрат.Организация = &Организация
		|	И РаспределениеПрочихЗатрат.Подразделение = &Подразделение
		|	И РаспределениеПрочихЗатрат.НаправлениеДеятельности = &НаправлениеДеятельности
		|	И РаспределениеПрочихЗатрат.СтатьяРасходов = &СтатьяРасходов
		|	И РаспределениеПрочихЗатрат.АналитикаРасходов = &АналитикаРасходов
		|	И РаспределениеПрочихЗатрат.Дата МЕЖДУ &ПериодНачало И &ПериодОкончание
		|	И НЕ РаспределениеПрочихЗатрат.Ссылка = &ТекущийДокумент
		|	И (ВЫБОР
		|			КОГДА &УправленческийУчет
		|				ТОГДА РаспределениеПрочихЗатрат.УправленческийУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ 
		|		ИЛИ
		|		ВЫБОР
		|			КОГДА &РегламентированныйУчет
		|				ТОГДА РаспределениеПрочихЗатрат.РегламентированныйУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		//++ НЕ УТ

		//++ Локализация
		|		ИЛИ
		|		ВЫБОР
		|			КОГДА &НалоговыйУчет
		|				ТОГДА РаспределениеПрочихЗатрат.НалоговыйУчет
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		//-- Локализация

		//-- НЕ УТ
		|		ИЛИ
		|		ВЫБОР
		|			КОГДА &НДД
		|				ТОГДА РаспределениеПрочихЗатрат.НДД
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|)";
	
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("Подразделение",		Подразделение);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ПериодНачало",		НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ПериодОкончание",	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("ТекущийДокумент",	Ссылка);
	Запрос.УстановитьПараметр("СтатьяРасходов",		СтатьяРасходов);
	Запрос.УстановитьПараметр("АналитикаРасходов",	АналитикаРасходов);
	Запрос.УстановитьПараметр("УправленческийУчет",	УправленческийУчет);
	Запрос.УстановитьПараметр("РегламентированныйУчет",	РегламентированныйУчет);
	Запрос.УстановитьПараметр("НалоговыйУчет",		НалоговыйУчет);
	Запрос.УстановитьПараметр("НДД",				НДД);
		
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ТекстСообщения = НСтр("ru = 'В указанном периоде уже существует аналогичный документ.
								   |Операция не выполнена.';
								   |en = 'Similar document already exists in the specified period.
								   |Operation failed.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	//++ НЕ УТ	
	Если Не РаспределятьПоПартиям И Не РаспределятьПоПодразделениям
		И Не РаспределятьНаСтатьи И Не ОставитьВНЗП
		И НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не выбрано ни одно направление распределения статьи расходов.';
					|en = 'No direction of expense item allocation is selected.'"),
				,
				"НаправлениеРаспределения",
				,
				Отказ);
	КонецЕсли;
		
	Если РаспределятьНаСтатьи И Списание.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не введено ни одной строки в список ""Другие статьи""';
				|en = 'No lines entered into the Other items list'"),
			,
			"Списание",
			,
			Отказ);
	КонецЕсли;
	
	Если Не НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьПроизводства
		И (Не РаспределятьПоПартиям 
			Или ПартииУказаныВручную Или ПодразделенияУказаныВручную) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяКалькуляции");
	КонецЕсли;
	
	Если ПартииУказаныВручную 
		И ПартииПроизводства.Количество() = 0
		И ВыпускиБезРаспоряжения.Количество() = 0
		И Вручную.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указаны партии.';
				|en = 'Lots are not specified.'"),,,,	Отказ);
			
	КонецЕсли;
	
	Если Не ((РаспределятьПоПартиям Или РаспределятьПрямыеПоПартиям) И (РаспределятьНаСтатьи Или ОставитьВНЗП)
		И Не (ПартииУказаныВручную Или ПодразделенияУказаныВручную)) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоляСтоимостиНаПроизводство");
	КонецЕсли;
	
	Если Не РаспределятьПоПодразделениям Или 
		(РаспределятьПоПодразделениям И ПодразделенияУказаныВручную) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПодразделениям");
	КонецЕсли;
	
	Если Не РаспределятьНаСтатьи Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Списание");
	КонецЕсли;
	
	Если Не ПодразделенияУказаныВручную Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПоБазе");
	КонецЕсли;
	
	Если Не (РаспределятьПоПодразделениям Или РаспределятьНаОВЗ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Показатель");
	ИначеЕсли НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И Не (БазаРаспределенияПоПодразделениям = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяЕжемесячно
		Или БазаРаспределенияПоПодразделениям = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяПриИзменении) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Показатель");
	КонецЕсли;
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства 
		И (Не РаспределятьПоПартиям Или ПартииУказаныВручную) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
	КонецЕсли;

	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат 
		И (НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам
			Или НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
	КонецЕсли;
	
	Если Не ОставитьВНЗП Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоляСтоимостиНаНЗП");
	КонецЕсли;
	
	Если БазаРаспределенияПоПартиям = Перечисления.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат 
		И Не РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(Дата) Тогда		
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'База распределение ""Сумма материальных и трудозатрат"" доступна только для партионного учета 2.2.';
				|en = 'The ""Amount of material and labor costs"" allocation base is available only for lot accounting 2.2.'"),
			ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(Ссылка),
			"ПравилоРаспределенияПоЭтапам",
			"Объект",
			Отказ);
			
	КонецЕсли;
	
	СписокПроверяемыхУчетов = Новый СписокЗначений;
	СписокПроверяемыхУчетов.Добавить("УправленческийУчет", НСтр("ru = 'управленческий';
																|en = 'management'"));
	СписокПроверяемыхУчетов.Добавить("РегламентированныйУчет", НСтр("ru = 'регламентированный';
																	|en = 'local'"));
	
	//++ Локализация
	СписокПроверяемыхУчетов.Добавить("НалоговыйУчет", НСтр("ru = 'налоговый';
															|en = 'tax'"));
	//-- Локализация
	
	Если РасчетСебестоимостиЛокализация.ПолучитьФункциональнуюОпциюУчетПоНДД() Тогда
		СписокПроверяемыхУчетов.Добавить("НДД", НСтр("ru = 'налог на дополнительный доход';
													|en = 'additional income tax'"));
	КонецЕсли;
	
	ВедениеВУчетеЗаполнено = Ложь;
	МассивСтроковыхПредставлений = Новый Массив;
	Для каждого ЭлементСписка Из СписокПроверяемыхУчетов Цикл
		ВедениеВУчетеЗаполнено = ВедениеВУчетеЗаполнено ИЛИ ЭтотОбъект[ЭлементСписка.Значение];
		МассивСтроковыхПредставлений.Добавить(ЭлементСписка.Представление);
	КонецЦикла;
	
	Если Не ВедениеВУчетеЗаполнено Тогда
		
		ТекстОшибки = НСтр("ru = 'Укажите в каких видах учета должен отражаться документ (%1).';
							|en = 'Specify accounting kinds to record the document (%1).'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, СтрСоединить(МассивСтроковыхПредставлений, ", "));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(Ссылка),
			"УправленческийУчет", "Объект", Отказ);
			
	КонецЕсли;

	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаОВЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПодразделениям");
	КонецЕсли;
	
	//-- НЕ УТ	
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные
			И ОтборПоНаправлениямДеятельности.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заданы направления деятельности в отборе.';
					|en = 'Lines of business are not set up in the filter.'"),
				,
				"НаправлениеРаспределения",
				,
				Отказ);
				
		КонецЕсли;
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам
			И НаправленияДеятельности.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не введено ни одной строки в список ""Направления деятельности""';
					|en = 'No lines are added into the ""Lines of business"" list'"),
				,
				"НаправленияДеятельности",
				,
				Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НаправлениеРаспределения) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ИсточникДанных");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, 
		Документы.РаспределениеПрочихЗатрат.ПараметрыВыбораСтатейИАналитик());

КонецПроцедуры

#КонецОбласти

#КонецЕсли
