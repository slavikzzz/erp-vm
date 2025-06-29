
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	//++ Локализация

	//++ НЕ УТ
	Если ТолькоПросмотр Тогда
		ЗарплатаКадрыКлиентСервер.УстановитьРежимТолькоПросмотрВФормеРедактированияИстории(ЭтотОбъект);
	КонецЕсли;
	//-- НЕ УТ

	//-- Локализация
	МассивЗаписей = Неопределено;
	Если Не Параметры.Свойство("МассивЗаписей", МассивЗаписей) Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Для Каждого ЗаписьНабора Из МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			
			Элемент.ТекущиеДанные.ФизЛицо = ОбъектВладелец;
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
				Элемент.ТекущиеДанные.Период = КонецДня(ПоследнийПериод) + 1;
			Иначе
				Элемент.ТекущиеДанные.Период = ОбщегоНазначенияКлиент.ДатаСеанса();
			КонецЕсли;
			
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ");
			Элемент.ТекущиеДанные.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			ИндексТекущейСтроки = НаборЗаписей.Индекс(Элемент.ТекущиеДанные);
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений';
										|en = 'Enter information date'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].Период", , Отказ);
			ИначеЕсли НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ВидДокумента) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать вид документа';
										|en = 'Specify a document kind'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].ВидДокумента", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ЯвляетсяДокументомУдостоверяющимЛичность", Элемент.ТекущиеДанные.Период, Истина));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru = 'Уже есть запись о документе, являющемся удостоверении личности с указанной датой сведений';
												|en = 'Record on the identity document with the specified information date already exists'");
						ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НаборЗаписей.Количество() = 1 
		И НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
		Элемент.ТекущиеДанные.Период = Элемент.ТекущиеДанные.ДатаВыдачи;
	КонецЕсли;
	
	Элементы.НаборЗаписей.ОтборСтрок = Неопределено;
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаВыдачиПриИзменении(Элемент)
	ИдентификаторТекущейСтроки = Элементы.НаборЗаписей.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Период) И ЗначениеЗаполнено(ТекущаяСтрока.ДатаВыдачи) Тогда
				ТекущаяСтрока.Период = ТекущаяСтрока.ДатаВыдачи;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтотОбъект, "ДокументыФизическихЛиц", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	Результат = Истина;
	//++ Локализация

	//++ НЕ УТ
	Результат = ЗарплатаКадрыКлиент.ЗаблокироватьОбъектВФормеВладельцеПриРедактированииИстории(ЭтотОбъект);
	//-- НЕ УТ

	//-- Локализация
	Возврат Результат;
	
КонецФункции

#КонецОбласти