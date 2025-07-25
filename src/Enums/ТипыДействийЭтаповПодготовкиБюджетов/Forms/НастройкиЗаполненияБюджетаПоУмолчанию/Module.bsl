
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресАналитикаЗаполненияБюджета = Неопределено;
	Если НЕ Параметры.Свойство("ВидБюджета", ВидБюджета)
	 ИЛИ НЕ Параметры.Свойство("МодельБюджетирования", МодельБюджетирования)
	 ИЛИ НЕ Параметры.Свойство("АдресАналитикаЗаполненияБюджета", АдресАналитикаЗаполненияБюджета)
	 ИЛИ НЕ Параметры.Свойство("КлючСтроки", КлючСтроки) Тогда
		ТекстСообщения = НСтр("ru = 'Непосредственное открытие этой формы не предусмотрено. Для открытия формы можно воспользоваться кнопкой открытия значения в колонке ""Настройки измерений по умолчанию"" в форме настроек ввода бюджетов.';
								|en = 'Application cannot open this form explicitly. It opens implicitly when you select the value opening button in the ""Default measurement settings"" column in the form of budget input settings.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	АналитикаЗаполненияБюджета.Загрузить(ПолучитьИзВременногоХранилища(АдресАналитикаЗаполненияБюджета));
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	РеквизитыБюджета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "АналитикиШапки").Выгрузить();
	ТипыЗначенийАналитик = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(РеквизитыБюджета.ВыгрузитьКолонку("ВидАналитики"), "ТипЗначения");
	Для Сч = 1 По РеквизитыБюджета.Количество() Цикл
		ВидАналитики = РеквизитыБюджета[Сч - 1].ВидАналитики;
		Элементы["АналитикаЗаполненияБюджетаАналитика" + Сч].Заголовок = Строка(ВидАналитики);
		Элементы["АналитикаЗаполненияБюджетаАналитика" + Сч].ОграничениеТипа = ТипыЗначенийАналитик.Получить(ВидАналитики);
	КонецЦикла;
	
	КоличествоАналитик = РеквизитыБюджета.Количество();
	МаксимальноеКоличествоАналитик = БюджетированиеКлиентСервер.МаксимальноеКоличествоАналитик();
	Если КоличествоАналитик < МаксимальноеКоличествоАналитик Тогда
		Для Сч = КоличествоАналитик + 1 По МаксимальноеКоличествоАналитик Цикл
			Элементы["АналитикаЗаполненияБюджетаГруппаАналитика" + Сч].Видимость = Ложь;
			Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
				Стр["Аналитика" + Сч] = Неопределено;
				Стр["ДоступностьАналитика" + Сч] = Ложь;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыФО = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	ФормироватьБюджетыПоОрганизациям = ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоОрганизациям", ПараметрыФО);
	ФормироватьБюджетыПоПодразделениям = ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоПодразделениям", ПараметрыФО);
	
	Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
		Если Не ФормироватьБюджетыПоОрганизациям Тогда
			Стр.Организация = Неопределено;
			Стр.ДоступностьОрганизация = Ложь;
			Элементы.АналитикаЗаполненияБюджетаГруппаОрганизация.Видимость = Ложь;
		КонецЕсли;
		
		Если Не ФормироватьБюджетыПоПодразделениям Тогда
			Стр.Подразделение = Неопределено;
			Стр.ДоступностьПодразделение = Ложь;
			Элементы.АналитикаЗаполненияБюджетаГруппаПодразделение.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.АналитикаЗаполненияБюджета.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСтроки", КлючСтроки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АналитикаЗаполненияБюджетаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.АналитикаЗаполненияБюджета.ТекущиеДанные.КлючСтроки = КлючСтроки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Отказ = Ложь; 
	ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
	Если Не Отказ Тогда 
		Результат = Новый Структура("Адрес,КлючСтрокиНастройкиАналитики", СохранитьНастройкиНаСервере(), КлючСтроки );
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(АналитикаЗаполненияБюджета.Выгрузить(), Адрес);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Сч = 0;
	Для Каждого Стр Из АналитикаЗаполненияБюджета Цикл
		
		Если Стр.КлючСтроки = КлючСтроки Тогда 		
			Если Не ЗначениеЗаполнено(Стр.Сценарий) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке %1 не заполнен сценарий';
						|en = 'Scenario in line %1 is not filled in'"),
					Сч+1);
				ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"АналитикаЗаполненияБюджета[%1].Сценарий",
					Сч); 
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, ПутьКДанным, Отказ);
			КонецЕсли;
			
			Если ФормироватьБюджетыПоОрганизациям И Не ЗначениеЗаполнено(Стр.Организация) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке %1 не заполнена организация';
						|en = 'Company in line %1 is not filled in'"),
					Сч+1);
				ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"АналитикаЗаполненияБюджета[%1].Организация",
					Сч);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, ПутьКДанным, Отказ);
			КонецЕсли;
			
			Если ФормироватьБюджетыПоПодразделениям И Не ЗначениеЗаполнено(Стр.Подразделение) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке %1 не заполнено подразделение';
						|en = 'Business unit in line %1 is not filled in'"),
					Сч+1);
				ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"АналитикаЗаполненияБюджета[%1].Подразделение",
					Сч);	
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, ПутьКДанным, Отказ);
			КонецЕсли;
			Сч = Сч + 1;	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьВозможностьИзмененияАналитики(Команда)
	
	ТекущиеДанные = Элементы.АналитикаЗаполненияБюджета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяЯчейка = Элементы.АналитикаЗаполненияБюджета.ТекущийЭлемент;
	Если ТекущаяЯчейка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаДоступности = ИмяРеквизитаДоступности(ТекущаяЯчейка.Имя);
	ТекущиеДанные[ИмяРеквизитаДоступности] = Не ТекущиеДанные[ИмяРеквизитаДоступности];
	
КонецПроцедуры

&НаКлиенте
Функция ИмяРеквизитаДоступности(ИмяЯчейки)
	
	Если ИмяЯчейки = "АналитикаЗаполненияБюджетаСценарий" Тогда
		Возврат "ДоступностьСценарий"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаОрганизация" Тогда
		Возврат "ДоступностьОрганизация"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаПодразделение" Тогда
		Возврат "ДоступностьПодразделение"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика1" Тогда
		Возврат "ДоступностьАналитика1"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика2" Тогда
		Возврат "ДоступностьАналитика2"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика3" Тогда
		Возврат "ДоступностьАналитика3"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика4" Тогда
		Возврат "ДоступностьАналитика4"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика5" Тогда
		Возврат "ДоступностьАналитика5"
	ИначеЕсли ИмяЯчейки = "АналитикаЗаполненияБюджетаАналитика6" Тогда
		Возврат "ДоступностьАналитика6"
	КонецЕсли;

КонецФункции

#КонецОбласти