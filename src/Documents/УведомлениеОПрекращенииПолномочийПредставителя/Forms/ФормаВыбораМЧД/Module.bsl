
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	СинийЦвет 	= Новый Цвет(28, 85, 174);
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
	ЗапретитьИзменение 		= Ложь;
	СканированиеДоступно	= Ложь;
	
	СсылкаНаОтзыв = Параметры.СсылкаНаОтзыв;
	
	РежимЗаполненияУведомления = "0";
	
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
		ДополнительныеПараметры.Вставить("Фильтр", 					"XML-файл УПРУП СФР (*.xml)|*.xml");
		ДополнительныеПараметры.Вставить("ВозвращатьРазмер", 		Истина);
		ДополнительныеПараметры.Вставить("МножественныйВыбор", 		Ложь);
		
		ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(
			ОписаниеОповещения, 
			Новый УникальныйИдентификатор,
			НСтр("ru = 'Выберите xml-файл';
				|en = 'Выберите xml-файл'"),
			ДополнительныеПараметры);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Файл" Тогда
		Если ЭтоXmlФайл Тогда
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(XMLФайл.Адрес, XMLФайл.Имя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФайлНажатие(Элемент)
	
	ЭтоXmlФайл = СтрНайти(ВРег(Элемент.Имя), "XML");
	
	Если ЭтоXmlФайл Тогда
		XMLФайл = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если ЭтаФорма.РежимЗаполненияУведомления = "0" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДокументОснование", ДокументОснование);
		ОткрытьФорму("Документ.УведомлениеОПрекращенииПолномочийПредставителя.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
	Если ЭтаФорма.РежимЗаполненияУведомления = "1" Тогда
		Если НЕ ЗначениеЗаполнено(XMLФайл) ИЛИ НЕ ЗначениеЗаполнено(XMLФайл.Адрес) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не выбран файл уведомления о прекращении полномочий представителя';
					|en = 'Не выбран файл уведомления о прекращении полномочий представителя'"));
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗагрузитьДокументИзФайлаОбмена", Истина);
		ПараметрыФормы.Вставить("АдресФайла", XMLФайл.Адрес);
		ОткрытьФорму(
			"Документ.УведомлениеОПрекращенииПолномочийПредставителя.Форма.ФормаДокумента", 
			ПараметрыФормы,
			ЭтаФорма,,,,,);
		
		КонецЕсли;
		
	Если ЭтаФорма.РежимЗаполненияУведомления = "2" Тогда
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Организация", Организация);
		
		ЗначенияЗаполнения = Новый Структура();
		ЗначенияЗаполнения.Вставить("Организация", Организация);
		
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
			
		ОткрытьФорму("Документ.УведомлениеОПрекращенииПолномочийПредставителя.ФормаОбъекта", ДополнительныеПараметры,,Новый УникальныйИдентификатор);
			
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
		Если НЕ СтрНайти(Врег(ОписаниеФайла.Имя), "ПФР_") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Имя файла уведомления о прекращении полномочий представителя (ПФР) должно начинаться на ПФР_';
					|en = 'Имя файла уведомления о прекращении полномочий представителя (ПФР) должно начинаться на ПФР_'"));
			Возврат;
		КонецЕсли;
		
		Попытка
			УПРУП = ДокументооборотСКОВызовСервера.ЗначениеXMLФайлаПоАдресу(ОписаниеФайла.Адрес, "xmlns", "utf-8");
			Если УПРУП <> "http://пф.рф/УПРУП/2020-02-03" Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Выбран файл не уведомления о прекращении полномочий представителя (СФР)';
						|en = 'Выбран файл не уведомления о прекращении полномочий представителя (СФР)'"));
				Возврат;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Выбран файл не уведомления о прекращении полномочий представителя (СФР)';
					|en = 'Выбран файл не уведомления о прекращении полномочий представителя (СФР)'"),,,, Истина);
			Возврат;
		КонецПопытки;
		
		XMLФайл = Новый ФиксированнаяСтруктура(ОписаниеФайла);
		
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
		
	Форма.Элементы.ВыбратьИзБазы.Видимость = ?(Форма.РежимЗаполненияУведомления = "0", Истина, Ложь);
	Форма.Элементы.XML.Видимость = ?(Форма.РежимЗаполненияУведомления = "1", Истина, Ложь);
	Форма.Элементы.РучноеЗаполнение.Видимость = ?(Форма.РежимЗаполненияУведомления = "2", Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Владелец", Организация);
	ОткрытьФорму(
		"Документ.УведомлениеОПредоставленииПолномочийПредставителю.ФормаВыбора",
		Новый Структура("Отбор", ПараметрыФормы),
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимЗаполненияЗаявленияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
