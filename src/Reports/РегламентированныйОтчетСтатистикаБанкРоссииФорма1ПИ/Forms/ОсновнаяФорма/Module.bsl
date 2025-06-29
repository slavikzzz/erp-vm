
#Область ОбработчикиСобытийФормы

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
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 3));
	Форма.мДатаНачалаПериодаОтчета = НачалоКвартала(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	// Устнавливаем границы периода построения отчета.
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	мПериодичность = ПеречислениеПериодичностьКвартал;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	Если НЕ ЗначениеЗаполнено(Организация)
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
	КонецЕсли;
	
	ПолеСсылкаШаблонБанка = НСтр("ru = 'Файл PDF-шаблона формы 1-ПИ';
								|en = 'Файл PDF-шаблона формы 1-ПИ'");
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ПолеСсылкаИзмененияЗаконодательства = РегламентированнаяОтчетность.ПредставлениеСсылкиИзмененияЗаконодательства();
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = РегламентированнаяОтчетность.ОбщаяЧастьСсылкиНаИзмененияЗаконодательства(ИсточникОтчета);
	
	РегламентированнаяОтчетность.УстановитьОтборВФормеВыбораОтчета(ЭтаФорма);
	
	ИзменитьПериод(ЭтаФорма, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	// Ищем в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		
	    ВыбраннаяФорма = МассивСтрок[0];
		// Присваиваем.
	    мВыбраннаяФорма = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопирован.
		// Проверяем соответствие форм.
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
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
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
Процедура ВыбратьФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
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

&НаКлиенте
Процедура ПолеСсылкаШаблонБанкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(мВыбраннаяФорма) Тогда
		ПолучитьШаблоныБанка();
	КонецЕсли;
	
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

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьШаблоныБанка()
	
	Перем АдресВременногоХранилища;
	
	ПолучитьШаблоныБанкаНаСервере(АдресВременногоХранилища);
	
	#Если НЕ ВебКлиент Тогда
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог для сохранения шаблона банка";
	
	Если Диалог.Выбрать() Тогда
		
		КаталогСохранения = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Диалог.Каталог);
		
		ШаблоныБанка = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
		
		СписокСуществующихОбъектов = Новый СписокЗначений;
		
		Для Каждого ШаблонБанка Из ШаблоныБанка Цикл
			
			КороткоеИмяФайла = ШаблонБанка.ИмяФайлаШаблона;
			ПолноеИмяСохраняемогоФайла = КаталогСохранения + КороткоеИмяФайла;
			
			ОбъектСохраняемыйФайл = Новый Файл(ПолноеИмяСохраняемогоФайла);
			Попытка
				Если ОбъектСохраняемыйФайл.Существует() Тогда
					УдалитьФайлы(ПолноеИмяСохраняемогоФайла);
				КонецЕсли;
				ШаблонБанка.Шаблон.Записать(ПолноеИмяСохраняемогоФайла);
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл PDF-шаблона ""%1"" записан в каталог ""%2""';
						|en = 'Файл PDF-шаблона ""%1"" записан в каталог ""%2""'"), КороткоеИмяФайла, КаталогСохранения);
				Сообщение.Сообщить();
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Во время сохранения файла ""%1"" возникла ошибка:%2';
						|en = 'Во время сохранения файла ""%1"" возникла ошибка:%2'"), КороткоеИмяФайла, Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	#Иначе
	
	ШаблоныБанка = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	Для Каждого ШаблонБанка Из ШаблоныБанка Цикл
		КороткоеИмяФайла = ШаблонБанка.ИмяФайлаШаблона;
		НачатьПолучениеФайлаССервера(ШаблонБанка.Шаблон, ШаблонБанка.ИмяФайлаШаблона);
	КонецЦикла;
	
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьШаблоныБанкаНаСервере(АдресВременногоХранилища)
	
	ИмяШаблонаБанка = "ШаблонБанка" + СтрЗаменить(мВыбраннаяФорма, "ФормаОтчета", "");
	МакетШаблонаБанка = РегламентированнаяОтчетностьВызовСервера.ОбъектОтчета(
		ЭтаФорма.ИмяФормы).ПолучитьМакет(ИмяШаблонаБанка);
	
	ВремФайлШаблона = ПолучитьИмяВременногоФайла("zip");
	Попытка
		МакетШаблонаБанка.Записать(ВремФайлШаблона);
	Исключение
		УдалитьФайлы(ВремФайлШаблона);
		ВызватьИсключение "Не удалось сохранить архив шаблона банка во временный файл." + Символы.ПС + ОписаниеОшибки();
	КонецПопытки;
	
	ВремКаталог = ПолучитьИмяВременногоФайла("");
	ВремКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВремКаталог);
	СоздатьКаталог(ВремКаталог);
	
	Попытка
		АрхивШаблона = Новый ЧтениеZipФайла(ВремФайлШаблона);
		АрхивШаблона.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		АрхивШаблона.Закрыть();
	Исключение
		УдалитьФайлы(ВремКаталог);
		ВызватьИсключение "Не удалось распаковать архив шаблона банка.
				|" + ИнформацияОбОшибке().Описание;
		Возврат;
	КонецПопытки;
	
	ОбъектыФайл = НайтиФайлы(ВремКаталог, "*.pdf", Ложь);
	
	ШаблоныБанка = Новый Массив;
	
	Для Каждого ОбъектФайл Из ОбъектыФайл Цикл
		
		Если ОбъектФайл.Существует() Тогда
			
			ШаблонБанка = Новый Структура;
			ШаблонБанка.Вставить("ИмяФайлаШаблона", ОбъектФайл.Имя);
			
			Попытка
				
				ШаблонБанка.Вставить("Шаблон", Новый ДвоичныеДанные(ОбъектФайл.ПолноеИмя));
				ШаблоныБанка.Добавить(ШаблонБанка);
				
			Исключение
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось загрузить PDF-шаблон банка ""%1"":%2';
						|en = 'Не удалось загрузить PDF-шаблон банка ""%1"":%2'"), ОбъектФайл.Имя, Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШаблоныБанка, Новый УникальныйИдентификатор);
	
	УдалитьФайлы(ВремФайлШаблона);
	Попытка
		УдалитьФайлы(ВремКаталог);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Основная форма ""1-ПИ"" (удаление каталога с файлом шаблона)';
										|en = 'Основная форма ""1-ПИ"" (удаление каталога с файлом шаблона)'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти