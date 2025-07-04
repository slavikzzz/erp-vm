
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
		
		ДемонстрационныеСценарии.ЗаполнитьОписанияСценариевВФормеСценариямиДругогоОбъекта(Параметры.ЗначениеКопирования, ОписанияСценария);
		Объект.Статус    = Перечисления.СтатусыДемонстрационныхСценариев.ВРаботе;
		Объект.ТипГруппы = Перечисления.ТипыГруппДемонстрационныхСценариев.Обычная;
		ПриСозданииЧтенииНаСервере(); 
		
	КонецЕсли;
	
	ДемонстрационныеСценарии.ОбработатьПереданныеВФормуОбъектаПараметрыПоиска(ЭтотОбъект, Параметры);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДемонстрационныеСценарии.ЗаполнитьОписанияСценариев(ТекущийОбъект, ОписанияСценария);
	
	ПриСозданииЧтенииНаСервере();
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТипГруппыЧисло = 0 Тогда
		
		ТекущийОбъект.ТипГруппы = Перечисления.ТипыГруппДемонстрационныхСценариев.Обычная;
		
	Иначе
		
		ТекущийОбъект.ТипГруппы = Перечисления.ТипыГруппДемонстрационныхСценариев.Ветвление;
		
	КонецЕсли;
	
	ДемонстрационныеСценарии.ЗаписатьНовыеОписанияСценариевИзФормыОбъекта(ЭтотОбъект, ТекущийОбъект, Отказ);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДемонстрационныеСценарии_ПоискИЗамена" Тогда
		
		 ДемонстрационныеСценарииКлиент.ОбработатьСобытиеПоискаИЗамены(Параметр, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
КонецПроцедуры

&НаКлиенте
Процедура ТипГруппыПросмотрПриИзменении(Элемент)
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТекстСценарияЧтениеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ДемонстрационныеСценарииКлиент.ПриНажатииВПолеHTMLДокумента(ЭтотОбъект, Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСценарияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ДемонстрационныеСценарииКлиент.ПриНажатииВПолеHTMLДокумента(ЭтотОбъект,Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСценарияДокументСформирован(Элемент)
	
	Если ПараметрыПоискаПриОткрытии <> Неопределено Тогда
		
		ДемонстрационныеСценарииКлиент.ОткрытьФормуПоиска(ЭтотОбъект);
		ПараметрыПоискаПриОткрытии = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеревестиСЯзыкаПросмотра(Команда) 
	
	ОчиститьСообщения();
	
	ДемонстрационныеСценарииКлиент.ПеревестиСЯзыкаПросмотра(
		ЭтотОбъект, ТекстСценарияЧтение, ТекстСценария, ЯзыкСценарияЧтение, ЯзыкСценария, "ТекстСценария");
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиИЗаменить(Команда)
	
	ОткрытьФорму("Справочник.ДемонстрационныеСценарии.Форма.ПоискИЗамена",,ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура АльбомПроцессов(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	СценарииОтчета = Новый Массив;
	СценарииОтчета.Добавить(Объект.Ссылка);
	
	ПараметрыФормы = Новый Структура("СценарииОтчета",          СценарииОтчета);
	ПараметрыФормы = Новый Структура("НеВызыватьКомандуПечати", Истина);
	
	ОткрытьФорму("Справочник.ДемонстрационныеСценарии.Форма.АльбомПроцессов",
	             ПараметрыФормы, 
	             ЭтотОбъект,
	             Истина);
	
КонецПроцедуры

#Область РедактированиеСценариев

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ПрисоединенныйФайлСценария = ДемонстрационныеСценарииКлиентСервер.ПрисоединенныйФайлСценария(ЭтотОбъект, ЯзыкСценария);
	
	Если ПрисоединенныйФайлСценария = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ПослеЗавершенияРедактированияФайла", ЭтотОбъект);
	
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(ОбработчикОповещения, ПрисоединенныйФайлСценария, УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ОчиститьСообщения();
	
	Если Модифицированность
		Или Не ДемонстрационныеСценарииКлиентСервер.ПрисоединенныйФайлПоСценариюСоздан(ЭтотОбъект, ЯзыкСценария) Тогда
		
		ОповещениеПослеВопросаОЗаписи = Новый ОписаниеОповещения("ПослеВопросаЗаписатьНачалоРедактирования", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Перед началом редактирования текста сценария, его необходимо записать. Продолжить?';
							|en = 'Before editing the scenario text, save it. Continue?'");
		
		ПоказатьВопрос(ОповещениеПослеВопросаОЗаписи, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	ПрисоединенныйФайлСценария = ДемонстрационныеСценарииКлиентСервер.ПрисоединенныйФайлСценария(ЭтотОбъект, ЯзыкСценария);
	
	Если ПрисоединенныйФайлСценария = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайлов = Новый Массив;
	МассивФайлов.Добавить(ПрисоединенныйФайлСценария);
	
	РаботаСФайламиСлужебныйВызовСервера.ОсвободитьФайлы(МассивФайлов);
	
	ОбновитьДанныеПрисоединенныхФайловСценариев();
	
КонецПроцедуры

#КонецОбласти

#Область ИзменениеРежимаОтображения

&НаКлиенте
Процедура УстановитьВариантПросмотр(Команда)
	
	ПереключитьВариантОтображенияНаКлиенте("Просмотр");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантРедактирование(Команда)
	
	ПереключитьВариантОтображенияНаКлиенте("Редактирование");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантПеревод(Команда)
	
	ПереключитьВариантОтображенияНаКлиенте("Перевод");
	
КонецПроцедуры 

#КонецОбласти

#Область ИзменениеСтатуса

&НаКлиенте
Процедура УстановитьСтатусВРаботе(Команда)
	
	ИзменитьСтатус(ПредопределенноеЗначение("Перечисление.СтатусыДемонстрационныхСценариев.ВРаботе"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЕстьЗамечания(Команда)
	
	ИзменитьСтатус(ПредопределенноеЗначение("Перечисление.СтатусыДемонстрационныхСценариев.ЕстьЗамечания"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаПроверке(Команда)
	
	ИзменитьСтатус(ПредопределенноеЗначение("Перечисление.СтатусыДемонстрационныхСценариев.НаПроверке"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПроверено(Команда)
	
	ИзменитьСтатус(ПредопределенноеЗначение("Перечисление.СтатусыДемонстрационныхСценариев.Проверено"));
	
КонецПроцедуры

#КонецОбласти

#Область ПереключениеЯзыков

&НаКлиенте
Процедура Подключаемый_ИзменитьЯзыкРедактирования(Команда)

	ИмяКоманды = Команда.Имя;
	КодЯзыка     = ДемонстрационныеСценарииКлиентСервер.КодЯзыкаИзИмениКоманды(ИмяКоманды, "ПереключитьНаЯзыкРедактирования_");
	ПереключитьЯзыкСценария(ЭтотОбъект, КодЯзыка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьЯзыкПросмотра(Команда)
	
	ИмяКоманды = Команда.Имя;
	КодЯзыка = ДемонстрационныеСценарииКлиентСервер.КодЯзыкаИзИмениКоманды(ИмяКоманды, "ПереключитьНаЯзыкПросмотра_");
	ЯзыкСценарияЧтение = КодЯзыка;
	ПриИзмененииЯзыкаПросмотраНаСервере( КодЯзыка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияУправлениеВидимостью

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Если Объект.ТипГруппы = Перечисления.ТипыГруппДемонстрационныхСценариев.Ветвление Тогда
		
		ТипГруппыЧисло = 1;
		
	Иначе
		
		ТипГруппыЧисло = 0;
		
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	ЦветЗахваченТекущимПользователем = ЦветаСтиля.ФайлЗанятыйТекущимПользователем;
	ЦветЗахваченДругимПользователем  = ЦветаСтиля.ФайлЗанятыйДругимПользователем;
	ЕстьПравоРедактирования          = ПравоДоступа("Изменение", Метаданные.Справочники.ДемонстрационныеСценарии);
	
	ДемонстрационныеСценарии.УстановитьЯзыкиКонфигурацииВФорме(ЭтотОбъект);
	ДемонстрационныеСценарии.СоздатьЭлементыФормыЯзыкиКонфигурации(ЭтотОбъект);
	ДемонстрационныеСценарии.УстановитьНастройкуПоЯзыкамВФорме(ЭтотОбъект, "ЯзыкСценарияЧтение", "ЯзыкСценария");
	
	УстановитьДанныеОтображаемыхСценариев(ЭтотОбъект);
	
	ДемонстрационныеСценарииКлиентСервер.ОтразитьТекущийСтатусНаФорме(ЭтотОбъект);
	
	ДемонстрационныеСценарии.ЗагрузитьНастройкуПоВариантуОтображенияФормы(
		ЭтотОбъект,
		ДемонстрационныеСценарии.ДоступныеВариантыОтображения(Истина),
		Метаданные.Справочники.ДемонстрационныеСценарии);
		
	ДемонстрационныеСценарииКлиентСервер.ОтразитьТекущиеЯзыкиНаФорме(ЭтотОбъект, "ЯзыкСценарияЧтение", "ЯзыкСценария");
	ДемонстрационныеСценарииКлиентСервер.СформироватьЗаголовокКомандыПеревода(ЯзыкСценарияЧтение, ЯзыкСценария, Элементы.Перевести);
	
	ТекстСценария = ПолучитьОписаниеНаЯзыке(ЭтотОбъект, ЯзыкСценария);
	ТекстСценарияЧтение = ПолучитьОписаниеНаЯзыке(ЭтотОбъект, ЯзыкСценарияЧтение);
	ДобавитьКТекстуСписокШаговГруппы();
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	Элементы = Форма.Элементы;
	
	ЭтоРежимРедактирования = (Форма.ВариантОтображенияФормы = "Редактирование");
	ЭтоРежимПеревод        = (Форма.ВариантОтображенияФормы = "Перевод");
	ЭтоРежимПросмотр       = (Форма.ВариантОтображенияФормы = "Просмотр");
	
	Элементы.СтраницыШапкаВариантыОтображения.ТекущаяСтраница = 
		?(ЭтоРежимРедактирования, Элементы.СтраницаВариантОтображенияРедактирование, Элементы.СтраницаВариантОтображенияПросмотр);
	
	Элементы.ГруппаКомментарийРодитель.Видимость  = ЭтоРежимРедактирования Или ЭтоРежимПеревод; 
	Элементы.ГруппаРедактирование.Видимость       = ЭтоРежимРедактирования Или ЭтоРежимПеревод;
	Элементы.ПодменюСтатус.Видимость              = ЭтоРежимРедактирования Или ЭтоРежимПеревод;
	
	Элементы.Перевести.Видимость = ЭтоРежимПеревод
	                               И Форма.ТекущийСценарийДоступенДляРедактирования
	                               И Не Форма.ТекущийСценарийРедактируетсяТекущимПользователем
	                               И Не Форма.Объект.Ссылка.Пустая(); 
	
	Элементы.ПодменюЯзыкПросмотра.Видимость = ЭтоРежимПросмотр Или ЭтоРежимПеревод;
	Элементы.ГруппаЧтение.Видимость         = ЭтоРежимПросмотр Или ЭтоРежимПеревод;
	
	Элементы.ТекстСценарияРедактировать.Видимость           = Форма.ТекущийСценарийДоступенДляРедактирования;
	Элементы.ТекстСценарияЗакончитьРедактирование.Видимость = Форма.ТекущийСценарийРедактируетсяТекущимПользователем;
	Элементы.ТекстСценарияОтменитьРедактирование.Видимость  = Форма.ТекущийСценарийРедактируетсяТекущимПользователем;
	
	Элементы.ТекстСценарияНайтиИЗаменить.Видимость          = Форма.ТекущийСценарийДоступенДляРедактирования
	                                                          И Не Форма.ТекущийСценарийРедактируетсяТекущимПользователем;
	
	Если Форма.ТекущийСценарийДоступенДляРедактирования Тогда
		Элементы.ГруппаКомандыСЯзыком.Группировка                                = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ДекорацияСостояниеРедактирования.ГоризонтальноеПоложение        = ГоризонтальноеПоложениеЭлемента.Лево;
		Элементы.ДекорацияСостояниеРедактирования.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
	Иначе
		Элементы.ГруппаКомандыСЯзыком.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		Элементы.ДекорацияСостояниеРедактирования.ГоризонтальноеПоложение        = ГоризонтальноеПоложениеЭлемента.Право;
		Элементы.ДекорацияСостояниеРедактирования.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;
	КонецЕсли;
	
	Элементы.ДекорацияСостояниеРедактирования.Видимость = Не ПустаяСтрока(Элементы.ДекорацияСостояниеРедактирования.Заголовок);
	
	ДемонстрационныеСценарииКлиентСервер.УстановитьПометкуКомандПереключенияВариантаОтображенияФормы(Форма);
	
	Элементы.ФормаАльбомПроцессов.Видимость = Не Форма.Объект.Ссылка.Пустая();
	
КонецПроцедуры

#КонецОбласти

#Область ИзменениеСтатуса

&НаКлиенте
Процедура ИзменитьСтатус(НовыйСтатус)

	Если НовыйСтатус = Объект.Статус
		Или Не ЗначениеЗаполнено(НовыйСтатус) Тогда
		Возврат;
	КонецЕсли; 
	
	Объект.Статус = НовыйСтатус;
	
	ДемонстрационныеСценарииКлиентСервер.ОтразитьТекущийСтатусНаФорме(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ПереключенияВариантовОтображения

&НаКлиенте
Процедура ПереключитьВариантОтображенияНаКлиенте(НовыйВариант)
	
	ПараметрыПереключения = ДемонстрационныеСценарииКлиентСервер.НовыйПараметрыПереключенияВариантаОтображения();
	ПараметрыПереключения.Форма                          = ЭтотОбъект;
	ПараметрыПереключения.НовыйВариант                   = НовыйВариант;
	ПараметрыПереключения.ИмяРеквизитаЯзыкЧтение         = "ЯзыкСценарияЧтение";
	ПараметрыПереключения.ИмяРеквизитаЯзыкРедактирование = "ЯзыкСценария";
	ПараметрыПереключения.ЯзыкиКонфигурации              = ЯзыкиКонфигурации;
	
	ДемонстрационныеСценарииКлиентСервер.ПереключитьВариантОтображения(ПараметрыПереключения); 
	
	Если ПараметрыПереключения.ВыполненоПереключениеЯзыка Тогда
		
		Если ПараметрыПереключения.ИмяРеквизитаПереключенЯзык = "ЯзыкСценарияЧтение" Тогда
			ПриИзмененииЯзыкаПросмотраНаСервере( ПараметрыПереключения.ПереключеноНаЯзык);
		ИначеЕсли ПараметрыПереключения.ИмяРеквизитаПереключенЯзык = "ЯзыкСценария" Тогда
			ПереключитьЯзыкСценария(ЭтотОбъект, ПараметрыПереключения.ПереключеноНаЯзык);
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеВидимостью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаДанныхСценариев

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДанныеОтображаемыхСценариев(Форма)

	УстановитьДанныеСценарияНаЯзыке(Форма, Форма.ЯзыкСценария);
	Форма.ТекстСценарияЧтение = ПолучитьОписаниеНаЯзыке(Форма, Форма.ЯзыкСценарияЧтение);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДанныеСценарияНаЯзыке(Форма, КодЯзыка)

	ДанныеСценария = ДемонстрационныеСценарииКлиентСервер.ДанныеСценарияНаЯзыке(Форма, КодЯзыка, "ОписанияСценария");
	
	Форма.ТекстСценария = ДанныеСценария.ТекстHTML;
	Форма.ТекущийСценарийДоступенДляРедактирования            = ДанныеСценария.ТекущийСценарийДоступенДляРедактирования;
	Форма.ТекущийСценарийРедактируетсяТекущимПользователем    = ДанныеСценария.ТекущийСценарийРедактируетсяТекущимПользователем;
	Форма.Элементы.ДекорацияСостояниеРедактирования.Заголовок = ДанныеСценария.ПредставлениеСостоянияРедактирования;

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЯзыкаПросмотраНаСервере(КодЯзыка)
	
	ТекстСценарияЧтение = ПолучитьОписаниеНаЯзыке(ЭтотОбъект, ЯзыкСценарияЧтение);
	ДобавитьКТекстуСписокШаговГруппы();
	ДемонстрационныеСценарииКлиентСервер.ОтразитьТекущиеЯзыкиНаФорме(ЭтотОбъект, "ЯзыкСценарияЧтение", "ЯзыкСценария");
	ДемонстрационныеСценарииКлиентСервер.СформироватьЗаголовокКомандыПеревода(ЯзыкСценарияЧтение, ЯзыкСценария, Элементы.Перевести); 
	УправлениеВидимостью(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьОписаниеНаЯзыке(Форма, КодЯзыка)
	
	Возврат ДемонстрационныеСценарииКлиентСервер.ТекстHTMLПоКодуЯзыка(Форма, КодЯзыка, "ОписанияСценария", "ТекстHTML");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьЯзыкСценария(Форма, КодЯзыка)
	
	Форма.ЯзыкСценария = КодЯзыка;
	УстановитьДанныеСценарияНаЯзыке(Форма, Форма.ЯзыкСценария);
	ДемонстрационныеСценарииКлиентСервер.ОтразитьТекущиеЯзыкиНаФорме(Форма, "ЯзыкСценарияЧтение", "ЯзыкСценария");
	ДемонстрационныеСценарииКлиентСервер.СформироватьЗаголовокКомандыПеревода(Форма.ЯзыкСценарияЧтение, Форма.ЯзыкСценария, Форма.Элементы.Перевести);
	
	УправлениеВидимостью(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКТекстуСписокШаговГруппы();
	
	Если Объект.Ссылка.Пустая() Тогда
		ТекстШаги = ТекстСценарияЧтение;
	КонецЕсли;
	
	ТекЭлементЧислоВхождений = СтрЧислоВхождений(Объект.ПолныйКод, "/");
	ШрифтГруппы              = ШрифтыСтиля.ШрифтГруппаШагиГруппы;
	ШрифтЗаголовок           = ШрифтыСтиля.ШрифтЗаголовокШагиГруппы;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДемонстрационныеСценарии.ПолныйКод     КАК ПолныйКод,
	|	ДемонстрационныеСценарии.Наименование  КАК Наименование,
	|	ДемонстрационныеСценарии.Ссылка        КАК Ссылка,
	|	ДемонстрационныеСценарии.Представление КАК Представление,
	|	ДемонстрационныеСценарии.ТипГруппы     КАК ТипГруппы,
	|	ДемонстрационныеСценарии.ЭтоГруппа     КАК ЭтоГруппа,
	|	ДемонстрационныеСценарии.Родитель      КАК Родитель
	|ИЗ
	|	Справочник.ДемонстрационныеСценарии КАК ДемонстрационныеСценарии
	|ГДЕ
	|	ДемонстрационныеСценарии.Родитель В ИЕРАРХИИ(&Родитель)
	|	И НЕ ДемонстрационныеСценарии.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПолныйКод ИЕРАРХИЯ
	|	"; 
	
	ИмяПоляКИзменению = ДемонстрационныеСценарии.ИмяМультиязычногоРеквизита("Наименование");
	МультиязычностьСервер.ИзменитьПолеЗапросаПодТекущийЯзык(Запрос.Текст, "Наименование");
	
	Запрос.УстановитьПараметр("Родитель", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ТекстСписокШаговГруппы = Новый ФорматированныйДокумент;
	ТекстСписокШаговГруппы.УстановитьHTML(ТекстСценарияЧтение, Новый Структура);
	
	ТекстСписокШаговГруппы.Добавить(Символы.ПС);
	ТекстСписокШаговГруппы.Добавить(Символы.ПС);
	
	ТекстШагиВГруппе = СтрШаблон(НСтр("ru = 'Шаги в группе: %1';
										|en = 'Steps in the group: %1'"), Выборка.Количество());
	
	Элемент = ТекстСписокШаговГруппы.Добавить(ТекстШагиВГруппе);
	Элемент.Шрифт = ШрифтЗаголовок; 
	
	ТекстСписокШаговГруппы.Добавить(Символы.ПС);
	ТекстСписокШаговГруппы.Добавить(Символы.ПС);
	
	Пока Выборка.Следующий() Цикл
		
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Выборка.Ссылка);
		ПредставлениеШага = СтрШаблон("%1 - %2 %3", Выборка.ПолныйКод, Выборка[ИмяПоляКИзменению], Символы.ПС);
		ЧислоВхождений = СтрЧислоВхождений(Выборка.Ссылка.ПолныйКод(), "/");
		Отступ = "";
		
		Для Инд = ТекЭлементЧислоВхождений + 2 По ЧислоВхождений Цикл
			Отступ = "    "+Отступ;
		КонецЦикла;
		
		ПредставлениеШага = Отступ + ПредставлениеШага;
		Элемент = ТекстСписокШаговГруппы.Добавить(ПредставлениеШага);
		Элемент.НавигационнаяСсылка = НавигационнаяСсылка;    
		
		Если Выборка.ЭтоГруппа Тогда
			Элемент.Шрифт = ШрифтГруппы;
		Иначе
			Элемент.Шрифт = ШрифтыСтиля.ОбычныйШрифтТекста;
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстШаги = "";
	Вложения = Новый Структура;
	
	ТекстСписокШаговГруппы.ПолучитьHTML(ТекстШаги, Вложения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОкончанияСобытийПрисоединенныхФайлов

&НаКлиенте
Процедура ПослеНачалаРедактированияФайла(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		ОбновитьДанныеПрисоединенныхФайловСценариев();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияРедактированияФайла(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Истина Тогда
		ОбновитьДанныеПрисоединенныхФайловСценариев();
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьДанныеПрисоединенныхФайловСценариев()

	ДемонстрационныеСценарии.ЗаполнитьОписанияСценариев(Объект, ОписанияСценария);
	УстановитьДанныеОтображаемыхСценариев(ЭтотОбъект);
	ДобавитьКТекстуСписокШаговГруппы();
	УправлениеВидимостью(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти 

#Область РедактированиеСценария

&НаКлиенте
Процедура ПослеВопросаЗаписатьНачалоРедактирования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РезультатЗаписи = Записать();
		Если РезультатЗаписи Тогда
			НачатьРедактированиеСценарияНаКлиенте();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеСценарияНаКлиенте()
	
	ПрисоединенныйФайлСценария = ДемонстрационныеСценарииКлиентСервер.ПрисоединенныйФайлСценария(ЭтотОбъект, ЯзыкСценария);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ПослеНачалаРедактированияФайла", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.РедактироватьСОповещением(ОбработчикОповещения, ПрисоединенныйФайлСценария, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти 

&НаКлиенте
Процедура ПослеЗакрытияФормыПоискаИЗамены(Результат, ДополнительныеПараметры) Экспорт

	ДемонстрационныеСценарииКлиент.ПослеЗакрытияФормыПоискаИЗамены(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросПослеПеревода(Результат, ДополнительныеПараметры) Экспорт
	
	ДемонстрационныеСценарииКлиент.ПослеПринятияРезультатовПеревода(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти
