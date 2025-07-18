//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	
	ДопУсловия = "";
	
	Если Параметры.Свойство("Отбор") Тогда
		
		Если Параметры.Отбор.Свойство("Подразделение") Тогда
			
			ОтборПодразделение = Параметры.Отбор.Подразделение;
			
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("Номенклатура") Тогда
			
			ДопУсловия = ДопУсловия + ?(ДопУсловия = "", "", " И ") + "Номенклатура = &Номенклатура";
			Запрос.УстановитьПараметр("Номенклатура", Параметры.Отбор.Номенклатура);
			
		КонецЕсли;
		
		//++ НЕ УТКА
		Если Параметры.Отбор.Свойство("ОснованиеДляПолучения") Тогда
			
			ДопУсловия = ДопУсловия + ?(ДопУсловия = "", "", " И ") + "ОснованиеДляПолучения = &ОснованиеДляПолучения";
			Запрос.УстановитьПараметр("ОснованиеДляПолучения", Параметры.Отбор.ОснованиеДляПолучения);
			
		КонецЕсли;
		//-- НЕ УТКА
		
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НастройкаПередачиМатериаловВПроизводство.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиМатериаловВПроизводство";
	
	Если ДопУсловия <> "" Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|ГДЕ
		|	" + ДопУсловия;
		
	КонецЕсли; 
	
	Элементы.ОтборПодразделение.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Подразделение"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	Оповестить("Запись_НастройкаПередачиМатериаловВПроизводство");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодразделению(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Подразделение",
		Форма.ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборПодразделение));

КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Устарело_Производство21