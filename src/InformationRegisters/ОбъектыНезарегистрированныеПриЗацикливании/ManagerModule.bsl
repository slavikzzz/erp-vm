///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура РегистрироватьВсе(Схема, Настройки) Экспорт
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Запрос = Новый Запрос;
	ТекстЗапроса = МакетКомпоновки.НаборыДанных.НаборДанныхДинамическогоСписка.Запрос;
	
	СхемаЗапрос = Новый СхемаЗапроса;
	СхемаЗапрос.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ВыбираемыеПоля = СхемаЗапрос.ПакетЗапросов[0].Операторы[0].ВыбираемыеПоля;
	ВыбираемыеПоля.Добавить("РегистрСведенийОбъектыНезарегистрированныеПриЗацикливании.ИмяРегистраСведений");
	ВыбираемыеПоля.Добавить("РегистрСведенийОбъектыНезарегистрированныеПриЗацикливании.ИзмеренияРегистраСведений");
	
	Запрос.Текст = СхемаЗапрос.ПолучитьТекстЗапроса();
	
	Для Каждого ЗначениеПараметра Из МакетКомпоновки.ЗначенияПараметров Цикл
		Запрос.УстановитьПараметр(ЗначениеПараметра.Имя,ЗначениеПараметра.Значение);
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл	
		РегистрацияИУдалениеЗаписи(Выборка);
	КонецЦикла;
		
КонецПроцедуры

Процедура РегистрироватьВыбранное(Адрес) Экспорт
	
	ТаблицаОбъектов = ПолучитьИзВременногоХранилища(Адрес);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаОбъектов.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	ТаблицаОбъектов.Объект КАК Объект,
		|	ТаблицаОбъектов.КлючРегистраСведений КАК КлючРегистраСведений
		|ПОМЕСТИТЬ ВТ_ТаблицаОбъектов
		|ИЗ
		|	&ТаблицаОбъектов КАК ТаблицаОбъектов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Объекты.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	Объекты.Объект КАК Объект,
		|	Объекты.КлючРегистраСведений КАК КлючРегистраСведений,
		|	Объекты.ИмяРегистраСведений КАК ИмяРегистраСведений,
		|	Объекты.ИзмеренияРегистраСведений КАК ИзмеренияРегистраСведений
		|ИЗ
		|	ВТ_ТаблицаОбъектов КАК ВТ_ТаблицаОбъектов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыНезарегистрированныеПриЗацикливании КАК Объекты
		|		ПО ВТ_ТаблицаОбъектов.УзелИнформационнойБазы = Объекты.УзелИнформационнойБазы
		|			И ВТ_ТаблицаОбъектов.Объект = Объекты.Объект
		|			И ВТ_ТаблицаОбъектов.КлючРегистраСведений = Объекты.КлючРегистраСведений";
	
	Запрос.УстановитьПараметр("ТаблицаОбъектов", ТаблицаОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл	
		РегистрацияИУдалениеЗаписи(Выборка);
	КонецЦикла;
		
КонецПроцедуры

Процедура РегистрацияИУдалениеЗаписи(Параметры)
	
	Если ЗначениеЗаполнено(Параметры.Объект) Тогда
			
		ПланыОбмена.ЗарегистрироватьИзменения(Параметры.УзелИнформационнойБазы, Параметры.Объект);
		
	Иначе
		
		ИмяРегистра = Параметры.ИмяРегистраСведений;
		Отбор = Параметры.ИзмеренияРегистраСведений.Получить();
		
		Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		
		Для Каждого Измерение Из Метаданные.РегистрыСведений[ИмяРегистра].Измерения Цикл
			Набор.Отбор[Измерение.Имя].Установить(Отбор[Измерение.Имя]);	
		КонецЦикла;
		
		Набор.Прочитать();
		
		ПланыОбмена.ЗарегистрироватьИзменения(Параметры.УзелИнформационнойБазы, Набор);
						
	КонецЕсли;
	
	Запись = РегистрыСведений.ОбъектыНезарегистрированныеПриЗацикливании.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Параметры, "УзелИнформационнойБазы,Объект,КлючРегистраСведений");
	Запись.Прочитать();
	Запись.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли