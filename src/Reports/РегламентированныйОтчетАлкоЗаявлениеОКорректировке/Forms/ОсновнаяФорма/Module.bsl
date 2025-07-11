
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	ОбработкаПериодичностьОтчета(Форма);
	
	ЗаполненНомерПриложения = ЗначениеЗаполнено(Форма.НомерПриложения);
	
	Форма.Элементы.УстановитьПредыдущийПериод.Доступность = ЗаполненНомерПриложения;
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.Доступность = ЗаполненНомерПриложения;
	Форма.Элементы.УстановитьСледующийПериод.Доступность = ЗаполненНомерПриложения;
	
	Форма.Элементы.СданныйОтчет.Доступность = ЗаполненНомерПриложения И ЗначениеЗаполнено(Форма.Организация);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Форма.Элементы.СданныйОтчет.Доступность;
		
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	//  РезультирующаяТаблица - действующие на выбранный период формы.
	//  Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		 
		Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 3));
		Форма.мДатаНачалаПериодаОтчета = НачалоКвартала(Форма.мДатаКонцаПериодаОтчета);
		
	ИначеЕсли Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьГод Тогда  // ежегодно
		
		Форма.мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 12));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
		
	ИначеЕсли Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьМесяц Тогда // ежемесячно
		
		Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
		Форма.мДатаНачалаПериодаОтчета = НачалоМесяца(Форма.мДатаКонцаПериодаОтчета);
		
	КонецЕсли;

	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаПериодичностьОтчета(Форма)
		
	// Периодичность четко определена, представление Периода однозначно.
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Очистить();
	СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина" );
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.ТолькоПросмотр = Истина;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокАлкоОтчетов()
	
	СписокАлкоОтчетов = Новый Структура;
	
	// Если нет подсистемы ОтчетностьПоАлкогольнойПродукции СоставАЛКО = Метаданные.Отчеты .
	
	МетаданныеПодсистемыАЛКО = Метаданные.Подсистемы.РегламентированнаяОтчетность.Подсистемы.ОтчетностьПоАлкогольнойПродукции;
	
	СоставАЛКО = МетаданныеПодсистемыАЛКО.Состав;
	
	МаркерАлкоОтчетов = "РегламентированныйОтчетАлкоПриложение";
	
	Для каждого Элемент Из СоставАЛКО Цикл
		
		Позиция = СтрНайти(Элемент.Имя, МаркерАлкоОтчетов);
		Если Позиция = 1 Тогда
		
			// Номер отчета АЛКО.
			ПозицияНачалаНомера = Позиция + СтрДлина(МаркерАлкоОтчетов); 
			СтрокаНомера = Сред(Элемент.Имя, ПозицияНачалаНомера);
			
			СписокАлкоОтчетов.Вставить("Отчет" + СтрокаНомера, Элемент.Имя);
						
			ЭтоОтчет2021года = (Число(СтрокаНомера) >= 19 И Число(СтрокаНомера) <= 26)
								ИЛИ
								(Число(СтрокаНомера) >= 30 И Число(СтрокаНомера) <= 31);
								
			ЭтоОтчет2019года = (Число(СтрокаНомера) >= 27 И Число(СтрокаНомера) <= 29);
			
			// Только "виноградные" алкодекларации переименованы.
			МассивВиноградных = РегламентированнаяОтчетностьАЛКОКлиентСервер.МассивНомеровВиноградныхДеклараций();
					
			ЭтоВиноградная = (МассивВиноградных.Найти(Число(СтрокаНомера)) <> Неопределено);
			
			СтрокаОтчетКакогоГода = "";
			Если ЭтоОтчет2021года Тогда			
				СтрокаОтчетКакогоГода = "";
			ИначеЕсли ЭтоОтчет2019года Тогда
				СтрокаОтчетКакогоГода = "(с 2019 г.) Алко ";
			ИначеЕсли ЭтоВиноградная Тогда				
				СтрокаОтчетКакогоГода = "(до 2019 г.) Алко ";	
			Иначе
				СтрокаОтчетКакогоГода = "(до 2021 г.) ";
			КонецЕсли; 
			
			СтрокаНомерОтчета = ?(ЭтоОтчет2021года ИЛИ ЭтоОтчет2019года, 
								Строка(Число(СтрокаНомера) - 18), СтрокаНомера);
			Если СтрокаНомера = "30" Тогда			
				СтрокаНомерОтчета = "9"
			ИначеЕсли СтрокаНомера = "31" Тогда
				СтрокаНомерОтчета = "10"
			КонецЕсли; 
			
			// Добавляем значения как числа ради простой сортировки, позже числа заменим строками.
			Элементы.НомерПриложения.СписокВыбора.Добавить(Число(СтрокаНомера), 
			 				СтрокаОтчетКакогоГода + "Приложение № " + СтрокаНомерОтчета);
		
		КонецЕсли; 
	
	КонецЦикла;
	
	Элементы.НомерПриложения.СписокВыбора.СортироватьПоЗначению(НаправлениеСортировки.Возр);
		
	Для каждого ЭлементСписка Из Элементы.НомерПриложения.СписокВыбора Цикл
	
		ЭлементСписка.Значение = Строка(ЭлементСписка.Значение);
	
	КонецЦикла; 
			
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
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	ПеречислениеПериодичностьГод 	 = Перечисления.Периодичность.Год;
	
	Если НЕ ЗначениеЗаполнено(НомерПриложения) Тогда	
		НомерПриложения = "";		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мПериодичность)
	 ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		мПериодичность = ПериодичностьПоНомеруПриложения(ЭтаФорма);
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
		
	Если НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = ТекущаяДатаСеанса();
		ИзменитьПериод(ЭтаФорма, -1);
	КонецЕсли;
		
	ИзменитьПериод(ЭтаФорма, 0);
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
	ЗаполнитьСписокАлкоОтчетов();
	
	НомерПриложения = Параметры.НомерПриложения;
	
	СданныйОтчет = Параметры.СданныйАлкоОтчет; 
	
	мПериодичность = ПериодичностьПоНомеруПриложения(ЭтаФорма);
	ПолеВыбораПериодичность = мПериодичность;
	
	ИзменитьПериод(ЭтаФорма, 0);
	
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
	// Ищем в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);	
	
	Если МассивСтрок.Количество() > 0 Тогда
		
		ВыбраннаяФорма = МассивСтрок[0];
		// Присваиваем.
		мВыбраннаяФорма		= ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок	= ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	// При изменении нужно очистить выбранный документ.
	СданныйОтчет = Неопределено;
	
	ИзменитьПериод(ЭтаФорма, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	// При изменении нужно очистить выбранный документ.
	СданныйОтчет = Неопределено;
	
	ИзменитьПериод(ЭтаФорма, 1);
	
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
	
	ПараметрыФормы.Вставить("НомерПриложения",          НомерПриложения);
	ПараметрыФормы.Вставить("СданныйАлкоОтчет",    		СданныйОтчет);
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
	
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
		
			ЭтаФорма.Активизировать();
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПериодичностьПоНомеруПриложения(Форма)

	Если ЗначениеЗаполнено(Форма.НомерПриложения) Тогда
		// Только "виноградные" алкодекларации годовые,
		// Остальные квартальные.
		МассивВиноградных = РегламентированнаяОтчетностьАЛКОКлиентСервер.МассивНомеровВиноградныхДеклараций();
	
		Если МассивВиноградных.Найти(Число(Форма.НомерПриложения)) <> Неопределено Тогда
			Возврат Форма.ПеречислениеПериодичностьГод;
		Иначе
			Возврат Форма.ПеречислениеПериодичностьКвартал;
		КонецЕсли;
						
	Иначе
		// По умолчанию квартал - наиболее частая периодичность для алкоотчетов.
		Возврат Форма.ПеречислениеПериодичностьКвартал;	
	КонецЕсли; 
	
КонецФункции

&НаКлиенте
Процедура НомерПриложенияПриИзменении(Элемент)
			
	// При изменении нужно очистить выбранный документ.
	СданныйОтчет = Неопределено;
	
	// Меняем периодичность.
	мПериодичность = ПериодичностьПоНомеруПриложения(ЭтаФорма);
	ПолеВыбораПериодичность = мПериодичность;
	
	ИзменитьПериод(ЭтаФорма, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура СданныйОтчетОчистка(Элемент, СтандартнаяОбработка)
	СданныйОтчет = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура СданныйОтчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Формируем параметры формы выбора отчета.
	
	// Поскольку крайне маловероятно, что когда нибудь количество алкоприложений
	// первысит 999 - можно обойтись без форматирования номера приложения, 
	// пробелов внутри строки номера не будет.
	ИсточникОтчета = СписокАлкоОтчетов["Отчет" + НомерПриложения];
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИсточникОтчета", 			ИсточникОтчета);
	ПараметрыФормы.Вставить("Организация", 				Организация);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета", 	мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета",	мДатаНачалаПериодаОтчета);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеВыбораОтчета", ЭтаФорма);
	
	ИмяФормыВыбораОтчета = СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "ФормаВыбораОтчета");
	
	ОткрытьФорму(ИмяФормыВыбораОтчета, ПараметрыФормы, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор, , , 
				ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораОтчета(Результат, ДопПараметры) Экспорт

	// Результат или ссылка на документ отчета, или неопределено.
	Если Значениезаполнено(Результат) Тогда
	    СданныйОтчет = Результат;		
	КонецЕсли; 

	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	// При изменении нужно очистить выбранный документ.
	СданныйОтчет = Неопределено;
	
	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти