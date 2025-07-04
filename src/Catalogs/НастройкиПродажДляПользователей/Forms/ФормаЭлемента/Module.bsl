
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	ПроцедураПриСозданииЧтенииНаСервере();
	
	Если СтрНайти(Параметры.ИмяПоля, "РМК")>0 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.РМК;
	КонецЕсли;
	
	Элементы.СкидкиНаценки.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям");
	Элементы.РМК.Видимость           = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	
	Если Элементы.СкидкиНаценки.Видимость И НЕ Элементы.РМК.Видимость Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СкидкиНаценки;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Не Элементы.СкидкиНаценки.Видимость И Элементы.РМК.Видимость Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.РМК;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПроцедураПриСозданииЧтенииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкиПродажДляПользователей", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОграничиватьРучныеСкидкиПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементовОграниченияРучныхСкидок(ЭтаФорма);
	
	Если Не Объект.ОграничиватьРучныеСкидки Тогда
		ОчиститьЗначенияРеквизитовСкидокНаценок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РМК_ИспользоватьПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементовРМК(ЭтаФорма);
	
	Если Не Объект.РМК_Использовать Тогда
		ОчиститьЗначенияРеквизитовНастроекРМК();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РМК_ВозвратТовараПриИзменении(Элемент)
	Если Не Объект.РМК_ВозвратТовара Тогда
		Объект.РМК_РазрешитьИзменениеЦеныПриВозвратеБезЧека = Ложь;
	КонецЕсли;
	ОбновитьВидимостьЭлементовРМК(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьИсключенияПоЦеновымГруппам(Команда)
	
	ИспользоватьИсключенияПоЦеновымГруппам = Истина;
	
	Элементы.ГруппаИспользоватьИсключенияПоЦеновымГруппам.Видимость = Не ИспользоватьИсключенияПоЦеновымГруппам;
	Элементы.ГруппаНеИспользоватьИсключенияПоЦеновымГруппам.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;
	Элементы.ЦеновыеГруппы.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;
	
КонецПроцедуры

&НаКлиенте
Процедура НеИспользоватьИсключенияПоЦеновымГруппам(Команда)
	
	Если Объект.ЦеновыеГруппы.Количество() > 0 Тогда
		РезультатВопроса = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("НеИспользоватьИсключенияПоЦеновымГруппамЗавершение", ЭтотОбъект), НСтр("ru = 'Таблица уточнений будет очищена, продолжить?';
																														|en = 'The table will be cleared. Do you want to continue?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
	НеИспользоватьИсключенияПоЦеновымГруппамФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура НеИспользоватьИсключенияПоЦеновымГруппамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    НеИспользоватьИсключенияПоЦеновымГруппамФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура НеИспользоватьИсключенияПоЦеновымГруппамФрагмент()
    
    Объект.ЦеновыеГруппы.Очистить();
    
    ИспользоватьИсключенияПоЦеновымГруппам = Ложь;
    
    Элементы.ГруппаИспользоватьИсключенияПоЦеновымГруппам.Видимость = Не ИспользоватьИсключенияПоЦеновымГруппам;
    Элементы.ГруппаНеИспользоватьИсключенияПоЦеновымГруппам.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;
    Элементы.ЦеновыеГруппы.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементовОграниченияРучныхСкидок(Форма)
	
	ОграничиватьРучныеСкидки = Форма.Объект.ОграничиватьРучныеСкидки;
	
	Форма.Элементы.ПроцентРучнойСкидки.Доступность  = ОграничиватьРучныеСкидки;
	Форма.Элементы.ПроцентРучнойНаценки.Доступность = ОграничиватьРучныеСкидки;
	Форма.Элементы.ЦеновыеГруппы.Доступность = ОграничиватьРучныеСкидки;
	Форма.Элементы.ЦеновыеГруппы.Доступность = ОграничиватьРучныеСкидки;
	
	Форма.Элементы.ГруппаНеИспользоватьИсключенияПоЦеновымГруппам.Доступность = ОграничиватьРучныеСкидки;
	Форма.Элементы.ГруппаИспользоватьИсключенияПоЦеновымГруппам.Доступность = ОграничиватьРучныеСкидки;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементовРМК(Форма)
	
	РМК_Использовать = Форма.Объект.РМК_Использовать;
	
	Форма.Элементы.РМК_ВозвратТовара.Доступность                    	= РМК_Использовать;
	Форма.Элементы.РМК_ВнесениеДенег.Доступность                    	= РМК_Использовать;
	Форма.Элементы.РМК_ВыемкаДенег.Доступность                      	= РМК_Использовать;
	Форма.Элементы.РМК_КорректировкаСтрок.Доступность               	= РМК_Использовать;
	Форма.Элементы.РМК_Отложить.Доступность                         	= РМК_Использовать;
	Форма.Элементы.РМК_Зарезервировать.Доступность                  	= РМК_Использовать;
	Форма.Элементы.РМК_ОткрытьСмену.Доступность                     	= РМК_Использовать;
	Форма.Элементы.РМК_ЗакрытьСмену.Доступность                     	= РМК_Использовать;
	Форма.Элементы.РМК_ИзменениеКартЛояльности.Доступность          	= РМК_Использовать;
	Форма.Элементы.РМК_РедактированиеИнформацииОКлиенте.Доступность 	= РМК_Использовать;
	Форма.Элементы.РМК_РазрешитьОплатуБезПодтвержденияОтСБП.Доступность = РМК_Использовать;
	Форма.Элементы.РМК_РазрешитьИзменениеЦеныПриВозвратеБезЧека.Доступность = РМК_Использовать И Форма.Объект.РМК_ВозвратТовара;
	
КонецПроцедуры

&НаСервере
Процедура ПроцедураПриСозданииЧтенииНаСервере()
	
	ОбновитьВидимостьЭлементовОграниченияРучныхСкидок(ЭтаФорма);
	ОбновитьВидимостьЭлементовРМК(ЭтаФорма);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЦеновыеГруппы") Тогда
		
		ИспользоватьИсключенияПоЦеновымГруппам = Объект.ЦеновыеГруппы.Количество() > 0;
		
		Элементы.ГруппаИспользоватьИсключенияПоЦеновымГруппам.Видимость = Не ИспользоватьИсключенияПоЦеновымГруппам;
		Элементы.ГруппаНеИспользоватьИсключенияПоЦеновымГруппам.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;
		Элементы.ЦеновыеГруппы.Видимость = ИспользоватьИсключенияПоЦеновымГруппам;
		
	Иначе
		
		ИспользоватьИсключенияПоЦеновымГруппам = Ложь;
		
		Элементы.ГруппаНеИспользоватьИсключенияПоЦеновымГруппам.Видимость = Ложь;
		Элементы.ГруппаИспользоватьИсключенияПоЦеновымГруппам.Видимость = Ложь;
		Элементы.ЦеновыеГруппы.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначенияРеквизитовОбъекта(МассивРеквизитовОбъекта, Значение)
	
	Для Каждого РеквизитОбъекта Из МассивРеквизитовОбъекта Цикл
		Объект[РеквизитОбъекта] = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗначенияРеквизитовСкидокНаценок()
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("ПроцентРучнойНаценки");
	МассивРеквизитов.Добавить("ПроцентРучнойСкидки");

	УстановитьЗначенияРеквизитовОбъекта(МассивРеквизитов, Ложь);

	НеИспользоватьИсключенияПоЦеновымГруппамФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗначенияРеквизитовНастроекРМК()

	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("РМК_ВозвратТовара");
	МассивРеквизитов.Добавить("РМК_ВнесениеДенег");
	МассивРеквизитов.Добавить("РМК_ВыемкаДенег");
	МассивРеквизитов.Добавить("РМК_КорректировкаСтрок");
	МассивРеквизитов.Добавить("РМК_Отложить");
	МассивРеквизитов.Добавить("РМК_Зарезервировать");
	МассивРеквизитов.Добавить("РМК_ОткрытьСмену");
	МассивРеквизитов.Добавить("РМК_ЗакрытьСмену");
	МассивРеквизитов.Добавить("РМК_ИзменениеКартЛояльности");
	МассивРеквизитов.Добавить("РМК_РедактированиеИнформацииОКлиенте");
	МассивРеквизитов.Добавить("РМК_РазрешитьОплатуБезПодтвержденияОтСБП");
	МассивРеквизитов.Добавить("РМК_РазрешитьИзменениеЦеныПриВозвратеБезЧека");
	
	УстановитьЗначенияРеквизитовОбъекта(МассивРеквизитов, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
