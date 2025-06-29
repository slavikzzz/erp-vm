///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Предмет            = Параметры.Предмет;
	ВидСообщения       = Параметры.ВидСообщения;
	РежимВыбора        = Параметры.РежимВыбора;
	ВладелецШаблона    = Параметры.ВладелецШаблона;
	ПараметрыСообщения = Параметры.ПараметрыСообщения;
	ПодготовитьШаблон  = Параметры.ПодготовитьШаблон;
	
	Если ТипЗнч(ПараметрыСообщения) = Тип("Структура") И ПараметрыСообщения.Свойство("ИмяФормыИсточникаСообщения") Тогда
		ИмяФормыИсточникаСообщения = ПараметрыСообщения.ИмяФормыИсточникаСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) И ТипЗнч(Предмет) <> Тип("Строка") Тогда
		ПолноеИмяТипаОснования = Предмет.Метаданные().ПолноеИмя();
	КонецЕсли;
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		ПредназначенДляSMS = Истина;
		Заголовок = НСтр("ru = 'Шаблоны сообщений SMS';
						|en = 'Text templates'");
	ИначеЕсли ВидСообщения = "Письмо" Тогда
		ПредназначенДляЭлектронныхПисем = Истина;
	Иначе
		Заголовок = НСтр("ru = 'Шаблоны сообщений';
						|en = 'Message templates'");
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ШаблоныСообщений) Тогда
		ЕстьПравоИзменения = Ложь;
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаСоздать.Видимость  = Ложь;
	Иначе
		ЕстьПравоИзменения = Истина;
	КонецЕсли;
	
	Если РежимВыбора Или ВидСообщения = "Произвольный" Тогда
		Элементы.ФормаСформироватьИОтправить.Видимость = Ложь;
		Элементы.ФормаСформировать.Заголовок = НСтр("ru = 'Выбрать';
													|en = 'Select'");
	ИначеЕсли ПодготовитьШаблон Тогда
		Элементы.ФормаСформироватьИОтправить.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокДоступныхШаблонов();
	ЗаполнитьСписокПечатныхФорм();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		Для Каждого ФорматСохранения Из МодульУправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
			ВыбранныеФорматыСохранения.Добавить(Строка(ФорматСохранения.ТипФайлаТабличногоДокумента), ФорматСохранения.Представление, Ложь, ФорматСохранения.Картинка);
		КонецЦикла;
		Элементы.ПодписьИПечать.Видимость = МодульУправлениеПечатью.НастройкиПечати().ИспользоватьПодписиИПечати;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ШаблоныСообщений" Тогда
		СсылкаНаВыбранныйЭлемент = Неопределено;
		Если Элементы.Шаблоны.ТекущиеДанные <> Неопределено Тогда
			СсылкаНаВыбранныйЭлемент = Элементы.Шаблоны.ТекущиеДанные.Ссылка;
		КонецЕсли;
		ЗаполнитьСписокДоступныхШаблонов();
		НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("Ссылка", СсылкаНаВыбранныйЭлемент));
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.Шаблоны.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПоказыватьФормуВыбораШаблонов Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
			УстановитьВыборФормата();
			СформироватьПредставлениеВыбранныхФорматов();
		КонецЕсли;
	Иначе
		ПараметрыОтправки = КонструкторПараметровОтправки();
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Ложь;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФорматВложенийНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореФорматаВложений", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВыборФорматаВложений(ОписаниеОповещения, ВыбранныеНастройкиФормата(), ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоны

&НаКлиенте
Процедура ШаблоныПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Если Копирование И НЕ Группа Тогда
		СоздатьНовыйШаблон(Элемент.ТекущиеДанные.Ссылка);
	Иначе
		СоздатьНовыйШаблон();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ШаблонВыбран = Элемент.ТекущиеДанные.Имя <> "<БезШаблона>";
		Элементы.ФормаСформироватьИОтправить.Доступность = ШаблонВыбран;
		Если ШаблонВыбран Или Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
			Если Элемент.ТекущиеДанные.ТипТекстаПисьма = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
				Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаФорматированныйДокумент;
				ПодключитьОбработчикОжидания("ОбновитьДанныеПредпросмотра", 0.2, Истина);
			Иначе
				Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаОбычныйТекст;
				ПредпросмотрОбычныйТекст.УстановитьТекст(Элемент.ТекущиеДанные.ТекстШаблона);
			КонецЕсли;
		Иначе
			Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаПечатныеФормы;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СформироватьСообщениеПоВыбранномШаблону();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьСообщениеПоВыбранномШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИОтправить(Команда)
	
	Если ТипЗнч(Элементы.Шаблоны.ТекущаяСтрока) <> Тип("Число") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	СформироватьИОтправить = Истина;
	Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
		ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки);
	Иначе
		ОтравитьСообщение(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	СоздатьНовыйШаблон();
КонецПроцедуры

&НаКлиенте
Процедура ВводПараметров(Шаблон, ПараметрыОтправки)
	
	ПараметрыДляЗаполнения = Новый Структура("Шаблон, Предмет", Шаблон, Предмет);
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаПараметров", ЭтотОбъект, ПараметрыОтправки);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.ЗаполнитьПроизвольныеПараметры", ПараметрыДляЗаполнения,,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьСообщениеПоВыбранномШаблону()

	Если ТипЗнч(Элементы.Шаблоны.ТекущаяСтрока) <> Тип("Число") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Или ВидСообщения = "Произвольный" Тогда
		Закрыть(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	
	Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
		ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки);
	Иначе
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСообщениеДляОтправки(ПараметрыОтправки)
	
	СформироватьБезШаблон = Не ЗначениеЗаполнено(ПараметрыОтправки.Шаблон);
	Если СформироватьБезШаблон И ПечатныеФормы.Количество() > 0 Тогда
		СохранитьВыборПечатныхФорм();
	КонецЕсли;
	
	АдресВременногоХранилища = Неопределено;
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	СформироватьБезШаблонаИПодписать = СформироватьБезШаблон И Подписать;
	Если СформироватьБезШаблонаИПодписать Тогда
		ПараметрыОтправки.ДополнительныеПараметры.НастройкиСохранения.УпаковатьВАрхив = Ложь;
	КонецЕсли;
	
	АдресРезультата = СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата); // см. ШаблоныСообщенийСлужебный.СформироватьСообщение
	
	Результат.Вставить("Предмет", Предмет);
	Результат.Вставить("Шаблон",  ПараметрыОтправки.Шаблон);
	Если ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПараметрыСообщения")
		И ТипЗнч(ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыСообщения, Ложь);
	КонецЕсли;
	
	Если СформироватьБезШаблонаИПодписать 
	   И ТипЗнч(Результат.Вложения) = Тип("Массив") 
	   И Результат.Вложения.Количество() > 0 Тогда
		ПараметрыОтправки.ДополнительныеПараметры.НастройкиСохранения.УпаковатьВАрхив = УпаковатьВАрхив;
		ПодписатьФайлы(Результат, ПараметрыОтправки);
	Иначе
		СформироватьСообщениеДляОтправкиОкончание(Результат, ПараметрыОтправки)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСообщениеДляОтправкиОкончание(Результат, ПараметрыОтправки)
	
	Если СформироватьИОтправить Тогда
		ПослеФормированияИОтправкиСообщения(Результат, ПараметрыОтправки);
	Иначе
		Если ПодготовитьШаблон Тогда
			Закрыть(Результат);
		Иначе
			Закрыть();
			ПоказатьФормуСообщения(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения)
	
	ПараметрыВызоваСервера = Новый Структура();
	ПараметрыВызоваСервера.Вставить("ПараметрыОтправки", ПараметрыОтправки);
	ПараметрыВызоваСервера.Вставить("ВидСообщения",      ВидСообщения);
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		ПараметрыОтправки.ДополнительныеПараметры.Вставить("РасширенныйСписокПолучателей", МодульВзаимодействия.ИспользуютсяПрочиеВзаимодействия());
	КонецЕсли;
	
	ШаблоныСообщенийСлужебный.СформироватьСообщениеВФоне(ПараметрыВызоваСервера, АдресВременногоХранилища, СформироватьИОтправить);
	
	Возврат АдресВременногоХранилища;
	
КонецФункции

// Параметры:
//  Результат - Соответствие - если данные введены пользователем:
//            - КодВозвратаДиалога - если отмена ввода данных
//            - Неопределено - если окно было закрыто
//  ПараметрыОтправки - см. ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки
//
&НаКлиенте
Процедура ПослеВводаПараметров(Результат, ПараметрыОтправки) Экспорт
	
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Отмена Тогда
		ПараметрыОтправки.ДополнительныеПараметры.ПроизвольныеПараметры = Результат;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщение(Знач ПараметрыОтправкиСообщения)
	
	Если ВидСообщения = "Письмо" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, ПараметрыОтправкиСообщения);
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
		КонецЕсли;
	ИначеЕсли ВидСообщения = "СообщениеSMS" Тогда
		СформироватьСообщениеДляОтправки(ПараметрыОтправкиСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, ПараметрыОтправки) Экспорт
	
	Если УчетнаяЗаписьНастроена = Истина Тогда
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры


// Параметры:
//  Результат - см. ШаблоныСообщенийСлужебный.РезультатОтправкиПисьма
//  ПараметрыОтправки - Структура
//
&НаКлиенте
Процедура ПослеФормированияИОтправкиСообщения(Результат, ПараметрыОтправки)
	
	Если ПустаяСтрока(Результат.ОписаниеОшибки)Тогда;
		Закрыть();
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбОткрытиеФормыСообщения", ЭтотОбъект, ПараметрыОтправки);
		ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + НСтр("ru = 'Открыть форму отправки сообщения?';
																		|en = 'Do you want to open the message?'");
		ПоказатьВопрос(Оповещение, ОписаниеОшибки, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение)
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			МодульОтправкаSMSКлиент= ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			
			ДополнительныеПараметры = Новый Структура("ПеревестиВТранслит");
			Если Сообщение.ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Сообщение.ДополнительныеПараметры);
			КонецЕсли;
			
			ДополнительныеПараметры.ПеревестиВТранслит = ?(Сообщение.ДополнительныеПараметры.Свойство("ПеревестиВТранслит"),
				Сообщение.ДополнительныеПараметры.ПеревестиВТранслит, Ложь);
			ДополнительныеПараметры.Вставить("Предмет", Предмет);
			Текст      = ?(Сообщение.Свойство("Текст"), Сообщение.Текст, "");
			
			Получатель = Новый Массив;
			ЭтоСписокЗначений = (ТипЗнч(Сообщение.Получатель) = Тип("СписокЗначений"));
			
			Для каждого СведенияОПолучателе Из Сообщение.Получатель Цикл
				Если ЭтоСписокЗначений Тогда
					Телефон                      = СведенияОПолучателе.Значение;
					ИсточникКонтактнойИнформации = "";
				Иначе 
					Телефон                      = СведенияОПолучателе.НомерТелефона;
					ИсточникКонтактнойИнформации = СведенияОПолучателе.ИсточникКонтактнойИнформации ;
				КонецЕсли;
				
				ДанныеПолучателя = Новый Структура();
				ДанныеПолучателя.Вставить("Представление",                СведенияОПолучателе.Представление);
				ДанныеПолучателя.Вставить("Телефон",                      Телефон);
				ДанныеПолучателя.Вставить("ИсточникКонтактнойИнформации", ИсточникКонтактнойИнформации);
				Получатель.Добавить(ДанныеПолучателя);
				
			КонецЦикла;
			
			МодульОтправкаSMSКлиент.ОтправитьSMS(Получатель, Текст, ДополнительныеПараметры);
		КонецЕсли;
	ИначеЕсли ВидСообщения = "Письмо" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	КонецЕсли;
	
	Если Сообщение.Свойство("СообщенияПользователю")
		И Сообщение.СообщенияПользователю <> Неопределено
		И Сообщение.СообщенияПользователю.Количество() > 0 Тогда
			Для каждого СообщенияПользователю Из Сообщение.СообщенияПользователю Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщенияПользователю.Текст,
					СообщенияПользователю.КлючДанных, СообщенияПользователю.Поле, СообщенияПользователю.ПутьКДанным);
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон = Неопределено)
	
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(Шаблон, Предмет, УникальныйИдентификатор);
	ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения       = ВидСообщения;
	ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ПараметрыСообщения;
	
	Если Не ЗначениеЗаполнено(Шаблон) Тогда
		Для Каждого ПечатнаяФорма Из ПечатныеФормы Цикл
			Если ПечатнаяФорма.Пометка Тогда
				ПараметрыОтправки.ДополнительныеПараметры.ПечатныеФормы.Добавить(ПечатнаяФорма.Значение);
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыОтправки.ДополнительныеПараметры.НастройкиСохранения = ВыбранныеНастройкиФормата();
	КонецЕсли;
	
	Возврат ПараметрыОтправки;
	
КонецФункции

// Параметры:
//  Результат - КодВозвратаДиалога
//  ПараметрыОтправки -см. ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки
// 
&НаКлиенте
Процедура ПослеВопросаОбОткрытиеФормыСообщения(Результат, ПараметрыОтправки) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьИОтправить = Ложь;
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйШаблон(ЗначениеКопирования = Неопределено)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидСообщения"          , ВидСообщения);
	ПараметрыФормы.Вставить("ПолноеИмяТипаОснования",
		?(ЗначениеЗаполнено(ПолноеИмяТипаОснования), ПолноеИмяТипаОснования, Предмет));
	ПараметрыФормы.Вставить("ТолькоДляАвтора",        Истина);
	ПараметрыФормы.Вставить("ВладелецШаблона",        ВладелецШаблона);
	ПараметрыФормы.Вставить("ЗначениеКопирования",    ЗначениеКопирования);
	ПараметрыФормы.Вставить("Новый",                  Истина);
	
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхШаблонов()
	
	Шаблоны.Очистить();
	
	ТипШаблона = "Произвольный";
	Если ПредназначенДляSMS Тогда
		ТипШаблона = "SMS";
	ИначеЕсли ПредназначенДляЭлектронныхПисем Тогда
		ТипШаблона = "Письмо";
	КонецЕсли;
	
	Запрос = ШаблоныСообщенийСлужебный.ПодготовитьЗапросДляПолученияСпискаШаблонов(ТипШаблона, Предмет, ВладелецШаблона);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
	Пока РезультатЗапроса.Следующий() Цикл
		НоваяСтрока = Шаблоны.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатЗапроса);
		
		Если РезультатЗапроса.ШаблонПоВнешнейОбработке
			И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
				МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
				ВнешнийОбъект = МодульДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(РезультатЗапроса.ВнешняяОбработка);
				ПараметрыШаблона = ВнешнийОбъект.ПараметрыШаблона();
				
				Если ПараметрыШаблона.Количество() > 1 Тогда
					ЕстьПроизвольныеПараметры = Истина;
				Иначе
					ЕстьПроизвольныеПараметры = Ложь;
				КонецЕсли;
		Иначе
			ПроизвольныеПараметры = РезультатЗапроса.ЕстьПроизвольныеПараметры.Выгрузить();
			ЕстьПроизвольныеПараметры = ПроизвольныеПараметры.Количество() > 0;
		КонецЕсли;
		
		НоваяСтрока.ЕстьПроизвольныеПараметры = ЕстьПроизвольныеПараметры;
	КонецЦикла;
	
	Если Шаблоны.Количество() = 0 Тогда
		НастройкиШаблоновСообщений = ШаблоныСообщенийСлужебныйПовтИсп.ПриОпределенииНастроек();
		ПоказыватьФормуВыбораШаблонов = НастройкиШаблоновСообщений.ВсегдаПоказыватьФормуВыбораШаблонов;
	Иначе
		ПоказыватьФормуВыбораШаблонов = Истина;
	КонецЕсли;
	
	Шаблоны.Сортировать("Представление");
	
	Если НЕ РежимВыбора И НЕ ПодготовитьШаблон Тогда
		ПерваяСтрока = Шаблоны.Вставить(0);
		ПерваяСтрока.Имя = "<БезШаблона>";
		ПерваяСтрока.Представление = НСтр("ru = '<Без шаблона>';
											|en = '<No template>'");
	КонецЕсли;
	
	Если Шаблоны.Количество() = 0 Тогда
		Элементы.ФормаСоздать.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.ВКоманднойПанели;
		Элементы.ФормаСоздать.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Элементы.ФормаСформировать.Доступность           = Ложь;
		Элементы.ФормаСформироватьИОтправить.Доступность = Ложь;
	Иначе
		Элементы.ФормаСформировать.Доступность           = Истина;
		Элементы.ФормаСформироватьИОтправить.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПредпросмотра()
	ТекущиеДанные = Элементы.Шаблоны.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьHTMLВФорматированныйДокумент(ТекущиеДанные.ТекстШаблона, ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьHTMLВФорматированныйДокумент(ТекстШаблонаПисьмаHTML, СсылкаНаТекущийОбъект);
	
	Сообщение = ШаблоныСообщенийСлужебный.КонструкторСообщения();
	
	ПараметрШаблона = Новый Структура("Шаблон, УникальныйИдентификатор");
	ПараметрШаблона.Шаблон = СсылкаНаТекущийОбъект;
	ПараметрШаблона.УникальныйИдентификатор = УникальныйИдентификатор;
	Сообщение.Текст = ТекстШаблонаПисьмаHTML;
	ШаблоныСообщенийСлужебный.ОбработатьHTMLДляФорматированногоДокумента(ПараметрШаблона, Сообщение, Истина);
	СтруктураВложений = Новый Структура();
	Для каждого ВложениеВHTML Из Сообщение.Вложения Цикл
		Изображение = Новый Картинка(ПолучитьИзВременногоХранилища(ВложениеВHTML.АдресВоВременномХранилище));
		СтруктураВложений.Вставить(ВложениеВHTML.Представление, Изображение);
	КонецЦикла;
	
	ПараметрыШаблона = ШаблоныСообщенийСлужебный.ПараметрыШаблона(СсылкаНаТекущийОбъект);
	СведенияОШаблоне = ШаблоныСообщенийСлужебный.СведенияОШаблоне(ПараметрыШаблона);
	
	Сообщение.Текст = ШаблоныСообщенийСлужебный.ПреобразоватьТекстШаблона(Сообщение.Текст , СведенияОШаблоне.Реквизиты, "ПараметрыВПредставление");
	Сообщение.Текст = ШаблоныСообщенийСлужебный.ПреобразоватьТекстШаблона(Сообщение.Текст , СведенияОШаблоне.ОбщиеРеквизиты, "ПараметрыВПредставление");
	ПредпросмотрФорматированныйДокумент.УстановитьHTML(Сообщение.Текст, СтруктураВложений);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыборФормата(Знач ФорматыСохранения = Неопределено)
	
	ЕстьВыбранныйФормат = Ложь;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ФорматыСохранения <> Неопределено Тогда
			ВыбранныйФормат.Пометка = ФорматыСохранения.Найти(ВыбранныйФормат.Значение) <> Неопределено;
		КонецЕсли;
			
		Если ВыбранныйФормат.Пометка Тогда
			ЕстьВыбранныйФормат = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВыбранныйФормат Тогда
		ВыбранныеФорматыСохранения[0].Пометка = Истина; // Выбор по умолчанию - первый в списке.
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеВыбранныхФорматов()
	
	ФорматВложений = "";
	КоличествоФорматов = 0;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			Если Не ПустаяСтрока(ФорматВложений) Тогда
				ФорматВложений = ФорматВложений + ", ";
			КонецЕсли;
			ФорматВложений = ФорматВложений + ВыбранныйФормат.Представление;
			КоличествоФорматов = КоличествоФорматов + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройкиФормата()
	
	Результат = ОбщегоНазначенияСлужебныйКлиент.НастройкиФорматаПечатнойФормы();
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			Результат.ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;

	Результат.УпаковатьВАрхив = УпаковатьВАрхив;
	Результат.ПереводитьИменаФайловВТранслит = ПереводитьИменаФайловВТранслит;
	Результат.ПодписьИПечать = ПодписьИПечать;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПриВыбореФорматаВложений(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> КодВозвратаДиалога.Отмена И ВыбранноеЗначение <> Неопределено Тогда
		УстановитьВыборФормата(ВыбранноеЗначение.ФорматыСохранения);
		УпаковатьВАрхив = ВыбранноеЗначение.УпаковатьВАрхив;
		ПереводитьИменаФайловВТранслит = ВыбранноеЗначение.ПереводитьИменаФайловВТранслит;
		Подписать = ВыбранноеЗначение.Подписать;
		СформироватьПредставлениеВыбранныхФорматов();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПечатныхФорм()
	
	Если ВидСообщения = "Произвольный" Или ВидСообщения = "СообщениеSMS" Или РежимВыбора Или ПодготовитьШаблон
		Или ТипЗнч(Предмет) = Тип("Строка") Или Не ЗначениеЗаполнено(Предмет) Тогда
		Элементы.ВыберитеПечатныеФормы.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		
		КомандыПечати = Неопределено;
		Если ЗначениеЗаполнено(ИмяФормыИсточникаСообщения) Тогда
			КомандыПечати = ОбщегоНазначения.ТаблицаЗначенийВМассив(МодульУправлениеПечатью.КомандыПечатиФормы(
				ИмяФормыИсточникаСообщения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Предмет.Метаданные())));
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КомандыПечати) Тогда
			Элементы.ВыберитеПечатныеФормы.Видимость = Ложь;
			Возврат;
		КонецЕсли;
		
		ВыбранныеРанееПечатныеФормы = ВыбранныеРанееПечатныеФормы();
		
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Пометка = ВыбранныеРанееПечатныеФормы.Найти(КомандаПечати.УникальныйИдентификатор) <> Неопределено;
			ПечатныеФормы.Добавить(КомандаПечати, КомандаПечати.Представление, Пометка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВыборПечатныхФорм()
	
	Если Не ЗначениеЗаполнено(ИмяФормыИсточникаСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	Для Каждого ПечатнаяФорма Из ПечатныеФормы Цикл
		Если ПечатнаяФорма.Пометка Тогда
			Идентификаторы.Добавить(ПечатнаяФорма.Значение.УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОтправкаПечатныхФормБезШаблона", ИмяФормыИсточникаСообщения, Идентификаторы);
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеРанееПечатныеФормы()
	
	Результат = Новый Массив;
	
	Если ЗначениеЗаполнено("ИмяФормыИсточникаСообщения") Тогда
		Результат = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ОтправкаПечатныхФормБезШаблона", ИмяФормыИсточникаСообщения, Новый Массив);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПодписатьФайлы(Результат, ПараметрыОтправки)
	ФайлыДляПодписания = Результат.Вложения;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Результат", Результат);
	Контекст.Вставить("ПараметрыОтправки", ПараметрыОтправки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СформироватьСообщениеДляОтправкиПродолжение", ЭтотОбъект, Контекст);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		ОписаниеДанных = Новый Структура;
		ОписаниеДанных.Вставить("ПоказатьКомментарий", Ложь);
		Если ФайлыДляПодписания.Количество() > 1 Тогда
			ОписаниеДанных.Вставить("Операция",            НСтр("ru = 'Подписание файлов';
																|en = 'Sign files'"));
			ОписаниеДанных.Вставить("ЗаголовокДанных",     НСтр("ru = 'Файлы';
																|en = 'Files'"));
			
			НаборДанных = Новый Массив;
			Для Каждого Файл Из ФайлыДляПодписания Цикл
				ОписаниеДанныхФайла = Новый Структура;
				ОписаниеДанныхФайла.Вставить("Представление", Файл.Представление);
				ОписаниеДанныхФайла.Вставить("Данные", Файл.АдресВоВременномХранилище);
				ОписаниеДанныхФайла.Вставить("ОбъектПечати", Предмет);
				НаборДанных.Добавить(ОписаниеДанныхФайла);
			КонецЦикла;
			
			ОписаниеДанных.Вставить("НаборДанных", НаборДанных);
			ОписаниеДанных.Вставить("ПредставлениеНабора", "Файлы (%1)");
		Иначе
			Файл = ФайлыДляПодписания[0];
			ОписаниеДанных.Вставить("Операция",        НСтр("ru = 'Подписание файла';
															|en = 'Sign file'"));
			ОписаниеДанных.Вставить("ЗаголовокДанных", НСтр("ru = 'Файл';
															|en = 'File'"));
			ОписаниеДанных.Вставить("Представление", Файл.Представление);
			ОписаниеДанных.Вставить("Данные", Файл.АдресВоВременномХранилище);
			ОписаниеДанных.Вставить("ОбъектПечати", Предмет);
		КонецЕсли;
		
		МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
		ПараметрыПодписи = МодульЭлектроннаяПодписьКлиент.НовыйТипПодписи();
		ПараметрыПодписи.ВыборДоверенности = Истина;
		МодульЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных,,ОписаниеОповещения, ПараметрыПодписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСообщениеДляОтправкиПродолжение(РезультатПодписания, Контекст) Экспорт
	
	Если ТипЗнч(РезультатПодписания) = Тип("Структура") И РезультатПодписания.Свойство("Успех") И Не РезультатПодписания.Успех Тогда
		Возврат;
	КонецЕсли;
	
	Вложения = ПолучитьФайлыПодписейИПоместитьВАрхив(РезультатПодписания, ПереводитьИменаФайловВТранслит, Контекст.ПараметрыОтправки.ДополнительныеПараметры.НастройкиСохранения);

	Результат = Контекст.Результат;
	Результат.Вложения.Очистить();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат.Вложения, Вложения);
	
	СформироватьСообщениеДляОтправкиОкончание(Результат, Контекст.ПараметрыОтправки);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьФайлыПодписейИПоместитьВАрхив(РезультатПодписания, ПереводитьИменаФайловВТранслит, НастройкиСохранения)
		
	МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
	
	ПараметрыПолученияФайлов = МодульЭлектроннаяПодписьСлужебный.ПараметрыПолученияФайлов();
	ПараметрыПолученияФайлов.ПереводитьИменаФайловВТранслит = ПереводитьИменаФайловВТранслит;
	Файлы = МодульЭлектроннаяПодписьСлужебный.ПолучитьФайлыИзРезультатаПодписания(
		РезультатПодписания, ПараметрыПолученияФайлов, УникальныйИдентификатор);
	
	ФайлыВоВременномХранилище = Новый Массив;
	Для Каждого Файл Из Файлы Цикл
		СтруктураОписанияФайла = Новый Структура("АдресВоВременномХранилище, Представление, Идентификатор, Кодировка");
		СтруктураОписанияФайла.АдресВоВременномХранилище = Файл.Данные;
		СтруктураОписанияФайла.Представление = Файл.ИмяФайла;
		ФайлыВоВременномХранилище.Добавить(СтруктураОписанияФайла);
	КонецЦикла;
	
	ФайлыВоВременномХранилище = ПоместитьФайлыВАрхив(ФайлыВоВременномХранилище, НастройкиСохранения);
	
	Возврат ФайлыВоВременномХранилище;
	
КонецФункции

&НаСервере
Функция ПоместитьФайлыВАрхив(ПечатныеФормыДокументов, ПереданныеНастройки)
	
	Результат = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		НастройкиСохранения = МодульУправлениеПечатью.НастройкиСохранения();
		ЗаполнитьЗначенияСвойств(НастройкиСохранения, ПереданныеНастройки);
		
		Если Не НастройкиСохранения.УпаковатьВАрхив Тогда
			Возврат ПечатныеФормыДокументов;
		КонецЕсли;
		ВариантСохранения = Неопределено; 
		ПереданныеНастройки.Свойство("ВариантСохранения", ВариантСохранения);
		УстанавливатьОбъектПечати = ВариантСохранения = "Присоединить";	
		
		ПереводитьИменаФайловВТранслит = НастройкиСохранения.ПереводитьИменаФайловВТранслит;
		
		ИмяВременногоКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
		СоздатьКаталог(ИмяВременногоКаталога);
		
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	
		Для Каждого СтруктураФайла Из ПечатныеФормыДокументов Цикл
				
			ДанныеФайла = ПолучитьИзВременногоХранилища(СтруктураФайла.АдресВоВременномХранилище);
			ПолноеИмяФайла = ИмяВременногоКаталога + СтруктураФайла.Представление;
			ПолноеИмяФайла = ФайловаяСистема.УникальноеИмяФайла(ПолноеИмяФайла);
			ДанныеФайла.Записать(ПолноеИмяФайла);
			ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
	
		КонецЦикла;
			
		ЗаписьZipФайла.Записать();
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		ОписаниеФайла = Новый Структура;
		Файл = Новый Файл(ИмяАрхива);
		ОписаниеФайла.Вставить("Представление", Файл.Имя);
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
		УдалитьФайлы(ИмяАрхива);
			
		УдалитьФайлы(ИмяВременногоКаталога);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти