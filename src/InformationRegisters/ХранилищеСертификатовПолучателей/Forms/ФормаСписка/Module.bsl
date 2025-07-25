#Область ОбработчикиКомандФормы

#Область ВыгрузитьСертификат

&НаКлиенте
Процедура ВыгрузитьСертификат(Команда)
	
	ТекущаяЗапись = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяЗапись <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные; // ДанныеФормыСтруктура
		ДанныеСертификата = ПолучитьДанныеСертификата(ТекущиеДанные.Отпечаток);
		Если ТекущиеДанные <> Неопределено Тогда
			ИмяФайлаСертификата = ТекущиеДанные.Наименование + ".cer";
		Иначе
			ИмяФайлаСертификата = "Сертификат.cer";
		КонецЕсли;
		
		ОписаниеСледующее = Новый ОписаниеОповещения("ВыгрузитьСертификатЗавершение", ЭтотОбъект);
		МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
		МодульСервисКриптографииDSSКлиент.СохранитьДанныеВФайл(ОписаниеСледующее, ДанныеСертификата, ИмяФайлаСертификата, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьСертификатЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВыполнения.Выполнено Тогда
		Сообщить(РезультатВыполнения.Ошибка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузитьСертификат

&НаКлиенте
Процедура ЗагрузитьСертификат(Команда)
	
	ТекстПодсказки = НСтр("ru = 'Укажите тип хранилища';
							|en = 'Укажите тип хранилища'");
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("AddressBook", "Получатели");
	СписокВыбора.Добавить("ROOT", "Корневые");
	СписокВыбора.Добавить("CA", "Удостоверяющие центры");
	СписокВыбора.Добавить("MY", "Личные");
	
	ОписаниеСледующее = Новый ОписаниеОповещения("ЗагрузитьСертификатПослеВыбораТипаХранилища", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеСледующее, СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСертификатПослеВыбораТипаХранилища(ТипХранилища, ДополнительныеПараметры) Экспорт
	
	Если ТипХранилища <> Неопределено Тогда
		ПараметрыЦикла = Новый Структура;
		ПараметрыЦикла.Вставить("ТипХранилища", ТипХранилища.Значение);
		ПараметрыЦикла.Вставить("АдресДанных", ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
		
		ОписаниеСледующее = Новый ОписаниеОповещения("ЗагрузитьСертификатЗавершение", ЭтотОбъект, ПараметрыЦикла);
		МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
		МодульСервисКриптографииDSSКлиент.ЗагрузитьДанныеИзФайла(ОписаниеСледующее, ".cer", ПараметрыЦикла.АдресДанных, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСертификатЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Выполнено Тогда
		НоваяСтрока = ДополнитьХранилищеСертификатов(ДополнительныеПараметры.АдресДанных, ДополнительныеПараметры.ТипХранилища);
		Если ЗначениеЗаполнено(НоваяСтрока) Тогда
			Элементы.Список.Обновить();
			Элементы.Список.ТекущаяСтрока = НоваяСтрока;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСертификата(ОтпечатокСертификата)
	
	ДанныеСертификата = КриптографияЭДКО.НайтиСертификатПолучателя(Новый Структура("Отпечаток", ОтпечатокСертификата));
	Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата.Сертификат);
	
КонецФункции

&НаСервереБезКонтекста
Функция ДополнитьХранилищеСертификатов(АдресДанных, ТипХранилища)
	
	Результат = Неопределено;
	
	Идентификатор = КриптографияЭДКО.ДобавитьСертификатПолучателя(АдресДанных, ТипХранилища);
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		Результат = РегистрыСведений.ХранилищеСертификатовПолучателей.СоздатьКлючЗаписи(
				Новый Структура("Идентификатор, ТипХранилища", Идентификатор, ТипХранилища));
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

