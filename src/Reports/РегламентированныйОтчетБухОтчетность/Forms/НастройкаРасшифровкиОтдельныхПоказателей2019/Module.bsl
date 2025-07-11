&НаКлиенте
Перем ЗакрытиеЧерезКнопки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ДеревоНастроек) = Тип("Строка") Тогда
		ЗначениеВДанныеФормы(ПолучитьИзВременногоХранилища(Параметры.ДеревоНастроек).Скопировать(), НастройкиВФорме);
	Иначе
		КопироватьДанныеФормы(Параметры.ДеревоНастроек, НастройкиВФорме);
	КонецЕсли;
	
	ИзменитьНазванияСтрок(Параметры.ДинамическиеНаименования);
	КонвертироватьДеревоНастроек(Параметры.УсловияДоступности);
	
	Если НЕ ЕстьСтрокиСЗаполненнойСущественностью(НастройкиВФорме) Тогда
		Элементы.НастройкиВФормеСущественность.Видимость = Ложь;
		Элементы.НастройкиВФормеМаксимальноеКоличество.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗакрытиеЧерезКнопки И Модифицированность Тогда
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Состав дополнительных строк был изменен.
											|Перед завершением работы рекомендуется сохранить новый состав,
											|иначе изменения будут утеряны.';
											|en = 'Состав дополнительных строк был изменен.
											|Перед завершением работы рекомендуется сохранить новый состав,
											|иначе изменения будут утеряны.'");
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'Состав дополнительных строк был изменен. Сохранить изменения?';
							|en = 'Состав дополнительных строк был изменен. Сохранить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиВФорме

&НаКлиенте
Процедура НастройкиВФормеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВФормеПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент.Имя = "НастройкиВФормеСущественность" Тогда
		
		Если НЕ Элемент.ТекущиеДанные.ДостДляРедактирования_Существенность Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
		
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "НастройкиВФормеМаксимальноеКоличество" Тогда
		
		Если НЕ Элемент.ТекущиеДанные.ДостДляРедактирования_МаксимальноеКоличество Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Состав дополнительных строк был изменен. Сохранить изменения?';
							|en = 'Состав дополнительных строк был изменен. Сохранить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	Иначе
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытиеЧерезКнопки = Истина;
	
	Если Модифицированность Тогда
		Закрыть(НастройкиВФорме);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажкиСнять(Команда)
	
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Ложь);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажкиУстановить(Команда)
	
	ПрисвоитьЗначениеФлажкам(НастройкиВФорме, Истина);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИзменитьНазванияСтрок(ДинамическиеНаименования)
	
	ДеревоНастроек = ДанныеФормыВЗначение(НастройкиВФорме, Тип("ДеревоЗначений"));
	
	Если ТипЗнч(ДинамическиеНаименования) = Тип("Соответствие") Тогда
		Для Каждого ПараметрНаименования Из ДинамическиеНаименования Цикл
			Токен = ПараметрНаименования.Ключ;
			Наименование = ПараметрНаименования.Значение;
			
			СтрокаДереваНастроек = ДеревоНастроек.Строки.Найти(Токен, "Наименование", Истина);
			Если СтрокаДереваНастроек <> Неопределено Тогда
				СтрокаДереваНастроек.Наименование = Наименование;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ЗначениеВДанныеФормы(ДеревоНастроек, НастройкиВФорме);
	
КонецПроцедуры

&НаСервере
Процедура КонвертироватьДеревоНастроек(УсловияДоступности)
	
	ДеревоНастроек = ДанныеФормыВЗначение(НастройкиВФорме, Тип("ДеревоЗначений"));
	
	Для Каждого ЭлементДерева Из ДеревоНастроек.Строки Цикл
		Если ЭлементДерева.Строки.Количество() > 0 Тогда
			НайденныеСтроки = ЭлементДерева.Строки.НайтиСтроки(Новый Структура("ВключатьВОтчет", 1));
			
			Если НайденныеСтроки.Количество() > 0 Тогда
				Если НайденныеСтроки.Количество() = ЭлементДерева.Строки.Количество() Тогда
					ЭлементДерева.ВключатьВОтчет = 1; // выбраны все дочерние строки
				ИначеЕсли НайденныеСтроки.Количество() < ЭлементДерева.Строки.Количество() Тогда
					ЭлементДерева.ВключатьВОтчет = 2; // выбрана часть дочерних строк
				КонецЕсли;
			Иначе
				ЭлементДерева.ВключатьВОтчет = 0; // не выбрана ни одна дочерняя строка
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УдалитьСтрокиПоУсловиюДоступности(ДеревоНастроек.Строки, УсловияДоступности);
	
	ЗначениеВДанныеФормы(ДеревоНастроек, НастройкиВФорме);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиПоУсловиюДоступности(СтрокиНастройки, УсловияДоступности)
	
	СтрокиКУдалению = Новый Массив;
	Для Каждого СтрокаНастройки Из СтрокиНастройки Цикл
		Если ЗначениеЗаполнено(СтрокаНастройки.УсловияДоступности)
		   И УсловияДоступности.Найти(СтрокаНастройки.УсловияДоступности) = Неопределено Тогда
			СтрокиКУдалению.Добавить(СтрокаНастройки);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
		СтрокиНастройки.Удалить(СтрокаКУдалению);
	КонецЦикла;
	
	Для Каждого СтрокаНастройки Из СтрокиНастройки Цикл
		УдалитьСтрокиПоУсловиюДоступности(СтрокаНастройки.Строки, УсловияДоступности);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		Закрыть(НастройкиВФорме);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗавершение(ОтветПользователя, ДополнительныеПараметры) Экспорт
	
	Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
		
		Закрыть(НастройкиВФорме);
		
	ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисвоитьЗначениеФлажкам(ВетвьДерева, ЗначениеФлажка)

	Для Каждого СтрокаДерева Из ВетвьДерева.ПолучитьЭлементы() Цикл
		
		СтрокаДерева.ВключатьВОтчет = ЗначениеФлажка;
		
		Если СтрокаДерева.ПолучитьЭлементы().Количество() > 0 Тогда
			
			ПрисвоитьЗначениеФлажкам(СтрокаДерева, ЗначениеФлажка);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ЕстьСтрокиСЗаполненнойСущественностью(ВетвьДерева)
	
	Для Каждого СтрокаДерева Из ВетвьДерева.ПолучитьЭлементы() Цикл
		Если ЗначениеЗаполнено(СтрокаДерева.Существенность) Тогда
			Возврат Истина;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() > 0 Тогда
				Если ЕстьСтрокиСЗаполненнойСущественностью(СтрокаДерева) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура НастройкиВФормеВключатьВОтчетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если Элементы.НастройкиВФорме.ТекущиеДанные.ВключатьВОтчет = 2 Тогда
		Элементы.НастройкиВФорме.ТекущиеДанные.ВключатьВОтчет = 0;
	КонецЕсли;
	
	Если Элементы.НастройкиВФорме.ТекущиеДанные.ПолучитьРодителя() = Неопределено
	   И Элементы.НастройкиВФорме.ТекущиеДанные.ПолучитьЭлементы().Количество() = 0 Тогда
	   
	   Возврат;
	   
   	КонецЕсли;
    	
	ИзменитьПометкуПодчиненных(Элементы.НастройкиВФорме.ТекущиеДанные, , , Истина, НастройкиВФорме);
			
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометкуПодчиненных(Узел, ВключатьВОтчет = Неопределено, СписокВыбранных = Неопределено,
	ОбновлятьПометкуРодительских = Ложь, Дерево = Неопределено)
	
	Если ВключатьВОтчет = Неопределено Тогда
		ВключатьВОтчет = Узел.ВключатьВОтчет;
	КонецЕсли;
	
	Если Дерево = Неопределено Тогда
		Дерево = Узел;
	КонецЕсли;
	
	Если СписокВыбранных = Неопределено Тогда
		Для Каждого Стр1 Из Узел.ПолучитьЭлементы() Цикл
			Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
				Стр2.ВключатьВОтчет = ВключатьВОтчет;
			КонецЦикла;
			Стр1.ВключатьВОтчет = ВключатьВОтчет;
		КонецЦикла;
	Иначе
		Для Каждого Стр1 Из Дерево.ПолучитьЭлементы() Цикл
			Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
				Стр2.ВключатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр2.Ссылка) <> Неопределено);
			КонецЦикла;
			Если Стр1.ПолучитьРодителя() <> Неопределено Тогда
				Стр1.ВключатьВОтчет = Число(СписокВыбранных.НайтиПоЗначению(Стр1.Ссылка) <> Неопределено);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Стр1 Из Дерево.ПолучитьЭлементы() Цикл
		Если Стр1.ПолучитьРодителя() <> Неопределено
		 ИЛИ Стр1.ПолучитьЭлементы().Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		СуммаПометок = 0;
		Для Каждого Стр2 Из Стр1.ПолучитьЭлементы() Цикл
			 СуммаПометок = СуммаПометок + Число(Стр2.ВключатьВОтчет);
		КонецЦикла;
		Если СуммаПометок = Стр1.ПолучитьЭлементы().Количество() Тогда
			Стр1.ВключатьВОтчет = 1;
		ИначеЕсли СуммаПометок = 0 Тогда
			Стр1.ВключатьВОтчет = 0;
		Иначе
			Стр1.ВключатьВОтчет = 2;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЗакрытиеЧерезКнопки = Ложь;
