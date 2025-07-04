
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии", ЭтотОбъект);
		НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогДляЖурналированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Оповещение = Новый ОписаниеОповещения("ПослеВыбораКаталога", ЭтотОбъект);
	ФайловаяСистемаКлиент.ВыбратьКаталог(Оповещение, НСтр("ru = 'Выберите каталог для сохранения файлов журнала.';
															|en = 'Select a directory for saving log files.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("НастройкаОбмена", Параметры.НастройкаОбмена);
	ОткрытьФорму("РегистрСведений.ПараметрыОбменСБанками.Форма.РедактированиеЗаписи", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЗначениеЗаполнено(Каталог) Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		СохранитьКаталог(Параметры.НастройкаОбмена, Каталог, СистемнаяИнформация.ИдентификаторКлиента);
		Закрыть(Каталог);
	Иначе
		ТекстСообщения = НСтр("ru = 'Укажите каталог для журналирования.';
								|en = 'Specify a directory for logging.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Каталог");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьКаталог(Знач НастройкаОбмена, Знач Каталог, Знач ИдентификаторКлиента)

	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи = РегистрыСведений.ПараметрыОбменСБанками.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.НастройкаОбмена = НастройкаОбмена;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.НастройкаОбмена = НастройкаОбмена;
	МенеджерЗаписи.КаталогДляЖурналирования = Каталог;
	МенеджерЗаписи.ИдентификаторКлиента = ИдентификаторКлиента;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталога(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "" Тогда
		Возврат;
	КонецЕсли;
	
	Каталог = Результат;
	
КонецПроцедуры

#КонецОбласти