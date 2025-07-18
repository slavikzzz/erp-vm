
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьДетализацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНаблюденияПриИзменении(Элемент)
	
	НастроитьДетализацию();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьДетализацию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьДетализацию()
	
	Детализация = Объект.Владелец.Детализация;
	
	Если Не ЗначениеЗаполнено(Детализация) Тогда
		
		Если Объект.Детализировать Тогда
			Объект.Детализировать = Ложь;
			Модифицированность = Истина;
		КонецЕсли;
		
		Элементы.Детализировать.Доступность = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Элементы.Детализировать.Доступность = Истина;
	
	ПредставлениеКлассификатора = Перечисления.ВидыСвободныхСтрокФормСтатистики.КраткоеПредставлениеКлассификатора(Детализация);
	Если ЗначениеЗаполнено(ПредставлениеКлассификатора) Тогда
		ШаблонЗаголовка = НСтр("ru = 'Детализировать по %1';
								|en = 'Itemize by %1'");
	Иначе
		ШаблонЗаголовка = НСтр("ru = 'Детализировать';
								|en = 'Itemize'");
	КонецЕсли;
	
	Элементы.Детализировать.Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, ПредставлениеКлассификатора);
	
КонецПроцедуры

#КонецОбласти