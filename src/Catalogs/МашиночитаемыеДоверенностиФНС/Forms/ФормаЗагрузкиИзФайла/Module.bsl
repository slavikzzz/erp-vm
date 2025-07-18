
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СинийЦвет 	= Новый Цвет(28, 85, 174);
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
	ЗапретитьИзменение 		= Ложь;
	СканированиеДоступно 	= Ложь;
	
	СсылкаНаДоверенность = Параметры.СсылкаНаДоверенность;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭтоXmlФайл = СтрНайти(ВРег(Элемент.Имя), "XML");
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "выберите" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиПослеВыбораФайла",
			ЭтотОбъект,
			Элемент.Имя);
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ДопустимыеТипыФайлов", 	?(ЭтоXmlФайл, "xml;", "sgn;bin;p7s;sign;sig;"));
		ДополнительныеПараметры.Вставить("ВозвращатьРазмер", 		Истина);
		ДополнительныеПараметры.Вставить("МножественныйВыбор", 		Ложь);
		
		ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(
			ОписаниеОповещения, 
			Новый УникальныйИдентификатор,
			НСтр("ru = 'Выберите xml-файл и подпись к нему';
				|en = 'Выберите xml-файл и подпись к нему'"),
			ДополнительныеПараметры);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Файл" Тогда
		Если ЭтоXmlФайл Тогда
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(XMLФайл.Адрес, XMLФайл.Имя);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Открытие файла подписи не предусмотрено';
															|en = 'Открытие файла подписи не предусмотрено'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФайлНажатие(Элемент)
	
	ЭтоXmlФайл = СтрНайти(ВРег(Элемент.Имя), "XML");
	
	Если ЭтоXmlФайл Тогда
		XMLФайл = Неопределено;
	Иначе
		Подпись = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если НЕ ЗначениеЗаполнено(XMLФайл) ИЛИ НЕ ЗначениеЗаполнено(XMLФайл.Адрес) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран файл машиночитаемой доверенности налогоплательщика';
														|en = 'Не выбран файл машиночитаемой доверенности налогоплательщика'"));
		Возврат;
	КонецЕсли;
	
	РезультатЗагрузки = ДокументооборотСКОВызовСервера.ЗагрузитьМЧД(
		XMLФайл.Адрес,
		СсылкаНаДоверенность,
		?(ЗначениеЗаполнено(Подпись), Подпись.Адрес, Неопределено));
	Если НЕ РезультатЗагрузки.Выполнено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗагрузки.Ошибка);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаДоверенность) Тогда
		Оповестить("Запись_МашиночитаемыеДоверенностиФНС", , РезультатЗагрузки.Ссылка);
		ПоказатьЗначение(, РезультатЗагрузки.Ссылка);
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиПослеВыбораФайла(Результат, ИмяЭлемента) Экспорт
	
	Если НЕ Результат.Выполнено ИЛИ Результат.ОписанияФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ОписаниеФайла = Результат.ОписанияФайлов[0];
	
	ЭтоXmlФайл = СтрНайти(ВРег(ИмяЭлемента), "XML");
	
	Если ЭтоXmlФайл Тогда
		Если НЕ СтрНайти(Врег(ОписаниеФайла.Имя), "ON_DOVEL") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Имя файла машиночитаемой доверенности налогоплательщика должно начинаться на ON_DOVEL';
					|en = 'Имя файла машиночитаемой доверенности налогоплательщика должно начинаться на ON_DOVEL'"));
			Возврат;
		КонецЕсли;
		
		КНД = ДокументооборотСКОВызовСервера.КНДФайлаПоАдресу(ОписаниеФайла.Адрес, "windows-1251");
		Если КНД <> "1110310" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Выбран файл не машиночитаемой доверенности налогоплательщика (КНД машиночитаемой доверенности налогоплательщика должен быть равен 1110310)';
					|en = 'Выбран файл не машиночитаемой доверенности налогоплательщика (КНД машиночитаемой доверенности налогоплательщика должен быть равен 1110310)'"));
			Возврат;
		КонецЕсли;
		
		XMLФайл = Новый ФиксированнаяСтруктура(ОписаниеФайла);
	Иначе
		
		Подпись = Новый ФиксированнаяСтруктура(ОписаниеФайла);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	РазмерФайла = ?(ЗначениеЗаполнено(Форма.XMLФайл), Форма.XMLФайл.Размер, 0);
	КоличествоФайлов = ?(ЗначениеЗаполнено(Форма.XMLФайл) И ЗначениеЗаполнено(Форма.XMLФайл.Адрес), 1, 0);
	ИмяПервогоФайла = ?(ЗначениеЗаполнено(Форма.XMLФайл), Форма.XMLФайл.Имя, "");
	ДокументооборотСКОКлиентСервер.ИзменитьОформлениеДокумента(
		Форма,
		"XML",
		РазмерФайла,
		КоличествоФайлов,
		ИмяПервогоФайла);
	
	РазмерФайла = ?(ЗначениеЗаполнено(Форма.Подпись), Форма.Подпись.Размер, 0);
	КоличествоФайлов = ?(ЗначениеЗаполнено(Форма.Подпись) И ЗначениеЗаполнено(Форма.Подпись.Адрес), 1, 0);
	ИмяПервогоФайла = ?(ЗначениеЗаполнено(Форма.Подпись), Форма.Подпись.Имя, "");
	ДокументооборотСКОКлиентСервер.ИзменитьОформлениеДокумента(
		Форма,
		"Подпись",
		РазмерФайла,
		КоличествоФайлов,
		ИмяПервогоФайла);
	
КонецПроцедуры

#КонецОбласти
