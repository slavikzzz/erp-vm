#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	мДатаНачалаПериодаОтчета = ?(Параметры.Свойство("мДатаНачалаПериодаОтчета"), Параметры.мДатаНачалаПериодаОтчета, Неопределено);
	мДатаКонцаПериодаОтчета  = ?(Параметры.Свойство("мДатаКонцаПериодаОтчета"), Параметры.мДатаКонцаПериодаОтчета, Неопределено);
	
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ИмяФормы);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	мТаблицаФормОтчета.Сортировать("ДатаНачалоДействия Убыв");
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	мДатаКонцаПериодаОтчета  = КонецКвартала(ТекущаяДатаСеанса());
	мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета );
	мПериодичность = Перечисления.Периодичность.Квартал;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	ПоказатьПериод(ЭтаФорма);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
	КонецЕсли;
	
	ПолеСсылкаИзмененияЗаконодательства = РегламентированнаяОтчетность.ПредставлениеСсылкиИзмененияЗаконодательства();
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = РегламентированнаяОтчетность.ОбщаяЧастьСсылкиНаИзмененияЗаконодательства(ИсточникОтчета);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Параметр = "Активизировать" И ИмяСобытия = Заголовок Тогда
		Активизировать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	СтрРедакцияФормы = ПолеРедакцияФормы;
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);	
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВыбраннаяФорма		= МассивСтрок[0];
		мВыбраннаяФорма		= ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок	= ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли; 
КонецПроцедуры

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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	Если мСкопированаФорма <> Неопределено Тогда
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Форма отчета изменилась, копирование невозможно!';
										|en = 'Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1';
																												|en = '%1'"),
			РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст()));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	
	ОткрытьФорму(СтрЗаменить(ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	ИзменитьПериод(ЭтаФорма, -3);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	ИзменитьПериод(ЭтаФорма, 3);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	СтрПериодОтчета = ПредставлениеПериода(
		НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
	Иначе
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоКвартала(Форма.мДатаКонцаПериодаОтчета);
	ПоказатьПериод(Форма);
КонецПроцедуры

#КонецОбласти
