
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьСрокПредставленияОтчетности(Форма)
	
	ГодСрокаПредставления = Год(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, 2));
	МесСрокаПредставления = Месяц(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, 2));
	СтрСрокПредставления = "";
	ЭтоВариант1 = Ложь;
	ЭтоВариант2 = Ложь;
	
	Если Форма.мВыбраннаяФорма = "ФормаОтчета2015Кв3" Тогда
		ЭтоВариант2 = Истина;
	ИначеЕсли Форма.мВыбраннаяФорма = "ФормаОтчета2011Кв4" Тогда
		Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2015 Тогда
			ЭтоВариант2 = Истина;
		Иначе
			ЭтоВариант1 = Истина;
		КонецЕсли;
	ИначеЕсли Форма.мВыбраннаяФорма = "ФормаОтчета2010Кв1" Тогда
		ЭтоВариант1 = Истина;
	КонецЕсли;
	
	Если ЭтоВариант2 Тогда
		// На бумаге - не позднее 15-го числа второго месяца, следующего за отчетным периодом.
		// В электронном виде - не позднее 20-го числа второго месяца, следующего за отчетным периодом.
		Форма.Элементы.СрокСдачи.Высота = 3;
		Форма.Элементы.НадписьСрокПредставленияОтчета.Высота = 3;
		ДатаСрокаПредставленияВПечВиде = Дата(ГодСрокаПредставления, МесСрокаПредставления, 15);
		ДатаСрокаПредставленияВЭлВиде  = Дата(ГодСрокаПредставления, МесСрокаПредставления, 20);
		СтрСрокПредставления = "Не позднее " + Формат(ДатаСрокаПредставленияВПечВиде,
			"ДФ=""дд ММММ гггг 'года'""") + " на бумажном носителе, не позднее "
			+ Формат(ДатаСрокаПредставленияВЭлВиде, "ДФ=""дд ММММ гггг 'года'""")
			+ " в форме электронного документа (ст.15 Закона N 212-ФЗ)";
	ИначеЕсли ЭтоВариант1 Тогда
		// Не позднее 1-го числа второго месяца, следующего за отчетным периодом.
		Форма.Элементы.СрокСдачи.Высота = 2;
		Форма.Элементы.НадписьСрокПредставленияОтчета.Высота = 2;
		ДатаСрокаПредставления = Дата(ГодСрокаПредставления, МесСрокаПредставления, 1);
		СтрСрокПредставления = "Не позднее " + Формат(ДатаСрокаПредставления,
			"ДФ=""дд ММММ гггг 'года'""") + " (ст.4 Закона N 155-ФЗ)";
	КонецЕсли;
	
	Форма.НадписьСрокПредставленияОтчета = НСтр("ru='" + СтрСрокПредставления + ".'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьКтоСдаетОтчет(Форма)
	
	СтрКтоСдает = "";
	ЭтоВариант1 = Ложь;
	ЭтоВариант2 = Ложь;
	
	Если Форма.мВыбраннаяФорма = "ФормаОтчета2015Кв3" Тогда
		ЭтоВариант2 = Истина;
	ИначеЕсли Форма.мВыбраннаяФорма = "ФормаОтчета2011Кв4" Тогда
		Если Год(Форма.мДатаКонцаПериодаОтчета) >= 2015 Тогда
			ЭтоВариант2 = Истина;
		Иначе
			ЭтоВариант1 = Истина;
		КонецЕсли;
	ИначеЕсли Форма.мВыбраннаяФорма = "ФормаОтчета2010Кв1" Тогда
		ЭтоВариант1 = Истина;
	КонецЕсли;
	
	Если ЭтоВариант2 Тогда
		Форма.Элементы.КтоСдаетОтчет.Высота = 8;
		Форма.Элементы.НадписьКтоСдаетОтчет.Высота = 8;
		СтрКтоСдает = "Плательщики страховых взносов по дополнительному тарифу для работодателей, использующих труд членов летных экипажей воздушных судов гражданской авиации (ст.1 Закона N 155-ФЗ), плательщики страховых взносов по дополнительному социальному обеспечению отдельных категорий работников организаций угольной промышленности (п.2 ст.6 Закона N 84-ФЗ)";
	ИначеЕсли ЭтоВариант1 Тогда
		Форма.Элементы.КтоСдаетОтчет.Высота = 4;
		Форма.Элементы.НадписьКтоСдаетОтчет.Высота = 4;
		СтрКтоСдает = "Плательщики страховых взносов по дополнительному тарифу для работодателей, использующих труд членов летных экипажей воздушных судов гражданской авиации (ст.1 Закона N 155-ФЗ)";
	КонецЕсли;
	
	Форма.НадписьКтоСдаетОтчет = НСтр("ru='" + СтрКтоСдает + ".'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	СтрПериодОтчета = ПредставлениеПериода(
		НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
			
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Если ГодПериода >= 2017 Тогда
			Форма.ОписаниеНормативДок = "C 01.01.2017 форма утратила силу (Федеральный закон от 03.07.2016 № 243-ФЗ).";
		Иначе
			Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	Если ГодПериода >= 2017 Тогда
		
		Форма.Элементы.ГруппаСрокПредставленияОтчета.Видимость = Ложь;
		Форма.НадписьСрокПредставленияОтчета = "";
		
		Форма.Элементы.ГруппаКтоСдаетОтчет.Видимость = Ложь;
		Форма.НадписьКтоСдаетОтчет = "";
		
	Иначе
		
		Форма.Элементы.ГруппаСрокПредставленияОтчета.Видимость = Истина;
		ИзменитьСрокПредставленияОтчетности(Форма);
		
		Форма.Элементы.ГруппаКтоСдаетОтчет.Видимость = Истина;
		ИзменитьКтоСдаетОтчет(Форма);
		
	КонецЕсли;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 3));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	Если НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(ОргПоУмолчанию) Тогда
		ОргПоУмолчанию = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(СписокДоступныхЮридическихЛиц().ВыгрузитьЗначения());
	
	Если Элементы.Организация.СписокВыбора.НайтиПоЗначению(Организация) = Неопределено Тогда
		Организация = Неопределено;
	КонецЕсли;
	
	ДоступныеОрганизацииОтсутствуют = Ложь;
	
	Если Элементы.Организация.СписокВыбора.Количество() = 0 Тогда
		
		ДоступныеОрганизацииОтсутствуют = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		
		Сообщение.Текст = ДоступныеОрганизацииОтсутствуютТекст();
		
		Сообщение.Сообщить();
		
		Элементы.Организация.КнопкаОткрытия = Ложь;
		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.Организация.СписокВыбора.Очистить();
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ПолеСсылкаИзмененияЗаконодательства = РегламентированнаяОтчетность.ПредставлениеСсылкиИзмененияЗаконодательства();
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = РегламентированнаяОтчетность.ОбщаяЧастьСсылкиНаИзмененияЗаконодательства(ИсточникОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВыбраннаяФорма = МассивСтрок[0];
		мВыбраннаяФорма     = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли;
	
	ИзменитьСрокПредставленияОтчетности(ЭтаФорма);
	
	ИзменитьКтоСдаетОтчет(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		Возврат;
		
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,НСтр("ru = 'Форма отчета изменилась, копирование невозможно!';
										|en = 'Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																						|en = '%1'"),
			РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ДопТекстОписания = НСтр("ru = 'Расчет РВ-3 представляют плательщики страховых взносов по дополнительному социальному обеспечению (п.2 ст.6 Закона N 84-ФЗ, ст.1 Закона N 155-ФЗ).';
							|en = 'Расчет РВ-3 представляют плательщики страховых взносов по дополнительному социальному обеспечению (п.2 ст.6 Закона N 84-ФЗ, ст.1 Закона N 155-ФЗ).'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения, ДопТекстОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = СписокДоступныхЮридическихЛиц(Текст);
	
	Если СписокВыбора.Количество() > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СписокВыбора;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	Текст = ВРег(СокрЛП(Элементы.Организация.ТекстРедактирования));
	
	Если НЕ (ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(Организация)) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокДоступныхЮридическихЛиц(Знач Текст = Неопределено)
	
	СписокВыбора = Новый СписокЗначений;
	РегламентированнаяОтчетность.ПолучитьСписокДоступныхЮридическихЛиц(СписокВыбора, Текст);
	
	Возврат СписокВыбора;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДоступныеОрганизацииОтсутствуютТекст()
	
	Возврат НСтр(
		"ru = 'Расчет РВ-3 представляют только плательщики страховых взносов по дополнительному социальному обеспечению (п.2 ст.6 Закона N 84-ФЗ, ст.1 Закона N 155-ФЗ).
		|В справочнике ""Организации"" сведения об организациях отсутствуют.';
		|en = 'Расчет РВ-3 представляют только плательщики страховых взносов по дополнительному социальному обеспечению (п.2 ст.6 Закона N 84-ФЗ, ст.1 Закона N 155-ФЗ).
		|В справочнике ""Организации"" сведения об организациях отсутствуют.'");
	
КонецФункции

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		Возврат;
	КонецЕсли; 
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
		+ ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПостфиксСсылки(мДатаКонцаПериодаОтчета);
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
	
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
		
			ЭтаФорма.Активизировать();
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти