
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Формула = Параметры.Формула;
	ИсходнаяФормула = Параметры.Формула;
	
	Параметры.Свойство("СтроковаяФормула", СтроковаяФормула);
	Параметры.Свойство("ТипРезультата", ТипРезультата);
	Если Параметры.Свойство("ФункцииИзОбщегоМодуля") Тогда
		ФункцииИзОбщегоМодуля = Новый ФиксированныйМассив(Параметры.ФункцииИзОбщегоМодуля);
	КонецЕсли;
	Параметры.Свойство("ФормулаДляВычисленияВЗапросе", ФормулаДляВычисленияВЗапросе);
	
	Параметры.Свойство("КлючОбъектаСохраняемыхНастроек", КлючОбъектаСохраняемыхНастроек);
	
	Если Параметры.Свойство("ВключитьЗначение") Тогда
		ВключитьЗначение = Параметры.ВключитьЗначение;
	Иначе
		ВключитьЗначение = Ложь;
	КонецЕсли;
	
	АдресДереваОперандов = Параметры.ДеревоОперандов;
	// Загрузка дерева с применением пользовательской настройки вывода не актуальных реквизитов и табличный частей.
	// Инициализация фиксированного соответствия ЗначенияОперандов.
	ЗагрузитьДеревоОперандов(); 
	
	АдресХранилищаДереваОператоров = Неопределено;
	Если Параметры.Свойство("Операторы", АдресХранилищаДереваОператоров) И ЭтоАдресВременногоХранилища(АдресХранилищаДереваОператоров) Тогда
		ДеревоОператоров = ПолучитьИзВременногоХранилища(АдресХранилищаДереваОператоров);
	Иначе
		ДеревоОператоров = РаботаСФормулами.ПолучитьСтандартноеДеревоОператоров();
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
	Если Параметры.Свойство("ОперандыЗаголовок") Тогда
		Элементы.ГруппаОперанды.Заголовок = Параметры.ОперандыЗаголовок;
		Элементы.ГруппаОперанды.Подсказка = Параметры.ОперандыЗаголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("НеИспользоватьПредставление") Тогда
		Элементы.Представление.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДеревоОперандов",
			"ИзменятьСоставСтрок",
			Ложь);
	
	Если Параметры.Свойство("Расширенный") И Параметры.Расширенный Тогда
		
		Расширенный           = Параметры.Расширенный;
		
		Представление = ?(Найти(Параметры.Представление, "["),"", Параметры.Представление);
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОК",
			"Заголовок",
			НСтр("ru = 'Задать произвольную формулу';
				|en = 'Apply formula'"));
			
		УстановитьПояснениеКОперандам(ЭтотОбъект, Параметры.Отбор);
		
		Если ВключитьЗначение Тогда
			
			Параметры.Свойство("ПараметрыРасшифровкиОперативногоПланирования", ПараметрыРасшифровкиОперативногоПланирования);
			
			УстановитьЗаголовокФормы(ЭтотОбъект, Параметры);
			
			УстановитьЗаголовокЗначенияОперандов();
			
			УстановитьПредставлениеВычисленияПоФормуле(Формула, ЗначенияОперандов, Вычисление);
			
		КонецЕсли;
		
		ВосстановитьНастройки();
		
		
	КонецЕсли;
	
	УстановитьУсловноеОформлениеОператоровИОперандов();
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность
		И ЗначениеЗаполнено(ИсходнаяФормула) И ИсходнаяФормула <> Формула Тогда
		
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
							|en = 'The data has changed. Do you want to save the changes?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ОчиститьСообщения();
		Если РаботаСФормуламиКлиент.ПроверитьФормулу(
				Формула,
				ОперандыФормулы(),
				ТипРезультата,
				ПараметрыПроверкиФормулы()) Тогда
			
			ПринудительноЗакрытьФорму = Истина;
			Если Расширенный Тогда
				СохранитьНастройки();
				Закрыть(Новый Структура("Формула, Представление, Вычисление",Формула, Представление, Вычисление));
			Иначе
				Закрыть(Формула);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОперандов

&НаКлиенте
Процедура ДеревоОперандовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОперандов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.РазрешаетсяВыборОперанда Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ДеревоОперандовЗначение"
		И ТекущиеДанные.СодержитЗначение
		И ПараметрыРасшифровкиОперативногоПланирования <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		Операнд = ТекущиеДанные.ПолныйИдентификаторСтроки;
		ВыполнитьРасшифровку(Операнд);
		
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Выбранный элемент помечен на удаление. Продолжить?';
							|en = 'The selected item is marked for deletion. Continue?'");
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТекущиеДанныеПолныйИдентификатор", ТекущиеДанные.ПолныйИдентификаторСтроки);
		ДополнительныеПараметры.Вставить("Режим", "Выбор");
		ОписаниеОповещения = Новый ОписаниеОповещения("ДеревоОперандовВыборОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ВставитьТекстВФормулу(РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(ТекущиеДанные.ПолныйИдентификаторСтроки));
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовВыборОкончаниеПеретаскиванияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет
	   И ДополнительныеПараметры.Режим = "Перетаскивание" Тогда
		
		НачалоСтроки  = 0;
		НачалоКолонки = 0;
		КонецСтроки   = 0;
		КонецКолонки  = 0;
		
		Элементы.Формула.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
		Элементы.Формула.ВыделенныйТекст = "";
		Элементы.Формула.УстановитьГраницыВыделения(НачалоСтроки, НачалоКолонки, НачалоСтроки, НачалоКолонки);
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да
		И ДополнительныеПараметры.Режим = "Выбор" Тогда

		Идентификатор = ДополнительныеПараметры.ТекущиеДанныеПолныйИдентификатор;
		ВставитьТекстВФормулу(РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(Идентификатор));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовПередРазворачиванием(Элемент, Строка, Отказ)
	
	ТекущиеДанные = ДеревоОперандов.НайтиПоИдентификатору(Строка);
	Если ТекущиеДанные.РазворачиватьДоРеквизитов
		И НЕ ТекущиеДанные.ПодчиненныеСтрокиРазворачивались Тогда
		// Если есть подчиненные реквизиты и для них не были получены реквизиты следующего уровня.
		РазвернутьПодчиненныеСтрокиДереваОперандов(Строка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РазвернутьПодчиненныеСтрокиДереваОперандов(ИдентификаторТекущейСтрокиДереваОперандов)
	
	РаботаСФормулами.РазвернутьСтрокуОперандаДереваФормы(ДеревоОперандов,
		ИдентификаторТекущейСтрокиДереваОперандов,
		МаксимальныйУровеньРазверткиСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоОперандов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	Если НЕ СтрокаДерева.РазрешаетсяВыборОперанда Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(
		СтрокаДерева.ПолныйИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтрокаДерева = Элемент.ТекущиеДанные;
	
	Если СтрокаДерева.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Выбранный элемент помечен на удаление. Продолжить?';
							|en = 'The selected item is marked for deletion. Continue?'");
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТекущиеДанныеПолныйИдентификатор", СтрокаДерева.ПолныйИдентификаторСтроки);
		ДополнительныеПараметры.Вставить("Режим", "Перетаскивание");
		ОписаниеОповещения = Новый ОписаниеОповещения("ДеревоОперандовВыборОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОператоры

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = Операторы.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ДанныеСтроки.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	ВставитьОператорВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если НЕ ТекущиеДанные.ЭтоГруппа Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущиеДанные.КонструкцияДляВставки;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Идентификатор = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОператорыОкончаниеПеретаскиванияЗавершение",
		                                              ЭтотОбъект,
		                                              Новый Структура("ФорматСтроки", ФорматСтроки));
		ФорматСтроки.Показать(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскиванияЗавершение(Текст, ДополнительныеПараметры) Экспорт
    
    ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
    
    Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
        ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
        Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОператорыПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Операторы.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ТекущийОператорПояснение = ТекущиеДанные.Пояснение;
	Иначе
		ТекущийОператорПояснение = "";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если РаботаСФормуламиКлиент.ПроверитьФормулу(Формула, ОперандыФормулы(), ТипРезультата, ПараметрыПроверкиФормулы()) Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Если Расширенный Тогда
			СохранитьНастройки();
			Закрыть(Новый Структура("Формула, Представление, Вычисление",Формула, Представление, Вычисление));
		Иначе
			Закрыть(Формула);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();
	РаботаСФормуламиКлиент.ПроверитьФормулуИнтерактивно(Формула,
		ОперандыФормулы(),
		ТипРезультата,
		ПараметрыПроверкиФормулы());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее



&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстДляВставки, Сдвиг = 0)
	
	СтрокаНач = 0;
	СтрокаКон = 0;
	КолонкаНач = 0;
	КолонкаКон = 0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	Если (КолонкаКон = КолонкаНач) И (КолонкаКон + СтрДлина(ТекстДляВставки)) > Элементы.Формула.Ширина / 8 Тогда
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
		
	Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	
	Если Не Сдвиг = 0 Тогда
		Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
		Элементы.Формула.УстановитьГраницыВыделения(СтрокаНач, КолонкаНач - Сдвиг, СтрокаКон, КолонкаКон - Сдвиг);
	КонецЕсли;
		
	ТекущийЭлемент = Элементы.Формула;
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Функция ОперандыФормулы()
	
	МассивОперандов = РаботаСФормуламиКлиентСервер.ОперандыТекстовойФормулы(Формула);
	
	// Поиск фиксированных операндов (например, видов цен), а также операндов пути данным.
	// Для операндов - путь к данным проверка осуществляется поиск только для первой части операнда (до первой точки),
	// т.к. дальнейший поиск затратен по времени.
	ОперандыНаУдаление = Новый Массив;
	Для Каждого Операнд Из МассивОперандов Цикл
		ПроверяемаяЧасть = Операнд;
		Если РазрешенныеОперанды.Найти(ПроверяемаяЧасть) = Неопределено Тогда
			ЧастиОперанда = РаботаСФормуламиКлиентСервер.ЧастиОперанда(Операнд);
			ПроверяемаяЧасть = ЧастиОперанда[0];
			Если ЧастиОперанда.Количество() > 1 Тогда
				ПроверяемаяЧасть = ПроверяемаяЧасть + ".";
			КонецЕсли;
			Если РазрешенныеОперанды.Найти(ПроверяемаяЧасть) = Неопределено Тогда
				ОперандыНаУдаление.Добавить(Операнд);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Для Каждого Операнд Из ОперандыНаУдаление Цикл
		Индекс = МассивОперандов.Найти(Операнд);
		Пока Индекс <> Неопределено Цикл
			МассивОперандов.Удалить(Индекс);
			Индекс = МассивОперандов.Найти(Операнд);
		КонецЦикла;
		
		ТекстОшибки = НСтр("ru = 'Не найден операнд ""[%1]""';
							|en = 'The ""[%1]"" operand is not found'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Операнд);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	КонецЦикла;
	
	Возврат МассивОперандов;
	
КонецФункции

&НаКлиенте
Процедура ВставитьОператорВФормулу()
	
	Если Элементы.Операторы.ТекущиеДанные.Идентификатор = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьОператорВФормулуЗавершение",
		                                              ЭтотОбъект,
		                                              Новый Структура("ФорматСтроки", ФорматСтроки));
		ФорматСтроки.Показать(ОписаниеОповещения);
		Возврат;
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.КонструкцияДляВставки,
		                      Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
	ВставитьОператорВФормулуФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		ВставитьТекстВФормулу(ТекстДляВставки, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	Иначе
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.КонструкцияДляВставки,
		                      Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
	ВставитьОператорВФормулуФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуФрагмент()
	
	Если Расширенный Тогда
		ТекущиеДанные = Элементы.Операторы.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.КонструкцияДляВставки) Тогда
			Родитель = ТекущиеДанные.ПолучитьРодителя();
			Если НЕ Родитель = Неопределено
				И (Родитель.Идентификатор = "ПримерыФормул"
					ИЛИ Родитель.Идентификатор = "ПоследниеИспользуемыеФормулы") Тогда
				Представление = ТекущиеДанные.Представление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
	Если ВключитьЗначение Тогда
		УстановитьПредставлениеВычисленияПоФормуле(Формула, ЗначенияОперандов, Вычисление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДеревоОперандовЗначение",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Вычисление",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияАвтоСумма",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операторы",
		"Шапка",
		ВключитьЗначение);
	
КонецПроцедуры

// Установить представление вычисления по формуле.
// 
// Параметры:
//  РасчетнаяФормула - Строка - Расчетная формула
//  ЗначенияОперандов - ФиксированноеСоответствие - Значения операндов
//  Вычисление - Строка - Вычисление
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеВычисленияПоФормуле(Знач РасчетнаяФормула, ЗначенияОперандов, Вычисление)
	
	Если Не ЗначениеЗаполнено(РасчетнаяФормула) Тогда
		Вычисление = "";
		Возврат;
	КонецЕсли;
	
	РасчетнаяФормула = УдалениеНезначимыхСимволов(РасчетнаяФормула);
	
	МассивОперандов = РаботаСФормуламиКлиентСервер.ОперандыТекстовойФормулы(РасчетнаяФормула);
	
	Для Каждого Операнд Из МассивОперандов Цикл
		ЗначениеОперанда = ЗначенияОперандов.Получить(Операнд);
		Если НЕ ЗначениеОперанда = Неопределено Тогда
			РасчетнаяФормула = СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", Формат(ЗначениеОперанда, "ЧРД=.; ЧН=0; ЧГ=0"));
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		#Если Клиент Тогда
			РезультатВычисления = Формат(Вычислить(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
		#Иначе
			РезультатВычисления = Формат(ОбщегоНазначения.ВычислитьВБезопасномРежиме(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
		#КонецЕсли
	Исключение
		Возврат;
	КонецПопытки;
	
	Вычисление = "= " + РезультатВычисления;
	
	Вычисление = УдалениеНезначимыхСимволов(Вычисление);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ПустаяСтрока(КлючОбъектаСохраняемыхНастроек) Тогда
		Возврат;
	КонецЕсли;
	
	МассивФормул = Неопределено;
	
	КоличествоСохраняемыхФормул = 10;
	
	УстановитьЗначениеНастройки("МассивФормул", МассивФормул);
	
	НовыйМассивФормул = Новый ТаблицаЗначений();
	НовыйМассивФормул.Колонки.Добавить("Представление");
	НовыйМассивФормул.Колонки.Добавить("Формула");
	
	Формула = УдалениеНезначимыхСимволов(Формула);
	Представление = УдалениеНезначимыхСимволов(Представление);
	
	Если Не ЗначениеЗаполнено(Формула) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(МассивФормул) = Тип("ТаблицаЗначений") И МассивФормул.Количество() > 0 Тогда
		
		НайденнаяСтрока = МассивФормул.Найти(Формула, "Формула");
		
		НовоеЗначение = НовыйМассивФормул.Добавить();
		НовоеЗначение.Представление = Представление;
		
		Если НайденнаяСтрока = Неопределено Тогда
			НовоеЗначение.Формула = Формула;
		Иначе
			НовоеЗначение.Формула = НайденнаяСтрока.Формула;
			МассивФормул.Удалить(НайденнаяСтрока);
		КонецЕсли;
		
		Для Каждого Элемент Из МассивФормул Цикл
			НовоеЗначение = НовыйМассивФормул.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеЗначение,Элемент);
			
			КоличествоСохраняемыхФормул = КоличествоСохраняемыхФормул - 1;
			
			Если КоличествоСохраняемыхФормул <=0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла; 
		
	Иначе
		
		НовоеЗначение = НовыйМассивФормул.Добавить();
		НовоеЗначение.Представление = Представление;
		НовоеЗначение.Формула		= Формула;
		
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъектаСохраняемыхНастроек, "МассивФормул", НовыйМассивФормул);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	Если ПустаяСтрока(КлючОбъектаСохраняемыхНастроек) Тогда
		Возврат;
	КонецЕсли;
	
	МассивФормул = Неопределено;
	
	УстановитьЗначениеНастройки("МассивФормул", МассивФормул);
	
	ДеревоОператоров = РеквизитФормыВЗначение("Операторы");
	
	Если ТипЗнч(МассивФормул) = Тип("ТаблицаЗначений") И МассивФормул.Количество() > 0 Тогда
		ПредставлениеГруппы = НСтр("ru = 'Последние используемые формулы';
									|en = 'Latest used formulas'");
		ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(ДеревоОператоров,
		                                                             "ПоследниеИспользуемыеФормулы",
		                                                             ПредставлениеГруппы);
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из МассивФормул Цикл
		ПредставлениеОператора = ?(ЗначениеЗаполнено(Элемент.Представление),Элемент.Представление,Элемент.Формула);
		РаботаСФормулами.ДобавитьОператор(ГруппаОператоров, Элемент.Формула, Элемент.Формула, ПредставлениеОператора);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеНастройки(ИмяНастройки, Настройка)
	
	ЗначениеНастройкиИзХранилища = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъектаСохраняемыхНастроек, ИмяНастройки);
	Если ЗначениеНастройкиИзХранилища <> Неопределено Тогда
		Настройка = ЗначениеНастройкиИзХранилища;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УдалениеНезначимыхСимволов(Знач ВходящаяСтрока)
	
	ВходящаяСтрока = СокрЛП(ВходящаяСтрока);
	ДлинаСтроки = СтрДлина(ВходящаяСтрока);
	КонечнаяСтрока = Строка("");
	
	Пока ДлинаСтроки > 0 Цикл 
		
		ПервыйСимвол = Лев(ВходящаяСтрока, 1);
		
		Если Не ПустаяСтрока(ПервыйСимвол) Тогда
			КонечнаяСтрока = КонечнаяСтрока + ПервыйСимвол;
			ДлинаСтроки = ДлинаСтроки - 1;
			Отступ = 2;
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + " ";
			ВходящаяСтрока = СокрЛ(ВходящаяСтрока);
			ДлинаСтроки = СтрДлина(ВходящаяСтрока);
			Отступ = 1;
		КонецЕсли;
		
		Если ДлинаСтроки > 1 Тогда
			ВходящаяСтрока = Сред(ВходящаяСтрока, Отступ, ДлинаСтроки);
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + Сред(ВходящаяСтрока, Отступ, 1);
			ДлинаСтроки = 0; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КонечнаяСтрока;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, Параметры)

	Форма.АвтоЗаголовок= Ложь;
	Форма.Заголовок = НСтр("ru = 'Редактирование формулы для ""';
							|en = 'Edit the formula for ""'") + Параметры.ЗаголовокЗначения + """";

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПояснениеКОперандам(Форма, Отбор)
	
	ЭлементПояснение = Форма.Элементы.ДекорацияПояснение;
	ТекстПояснения = "";
	Шрифт = Новый Шрифт(,,,Истина);
	
	ЕстьСклад								= Отбор.Свойство("ОтборСклад") И ЗначениеЗаполнено(Отбор.ОтборСклад);
	ЕстьПодразделениеПродажи				= Отбор.Свойство("ОтборПодразделениеПродажи") И ЗначениеЗаполнено(Отбор.ОтборПодразделениеПродажи);
	ЕстьПодразделениеЗакупки				= Отбор.Свойство("ОтборПодразделениеЗакупки") И ЗначениеЗаполнено(Отбор.ОтборПодразделениеЗакупки);
	ЕстьПодразделениеДиспетчер				= Отбор.Свойство("ОтборПодразделениеДиспетчер") И ЗначениеЗаполнено(Отбор.ОтборПодразделениеДиспетчер);
	ЕстьПодразделениеВнутреннихПотреблений 	= Отбор.Свойство("ОтборПодразделениеВнутреннихПотреблений") 
		И ЗначениеЗаполнено(Отбор.ОтборПодразделениеВнутреннихПотреблений);
	ЕстьПодразделение = ЕстьПодразделениеПродажи ИЛИ ЕстьПодразделениеЗакупки ИЛИ ЕстьПодразделениеДиспетчер 
		ИЛИ ЕстьПодразделениеВнутреннихПотреблений;
	ЕстьПартнер								= Отбор.Свойство("ОтборПартнер") И ЗначениеЗаполнено(Отбор.ОтборПартнер);
	ЕстьСоглашение 							= Отбор.Свойство("ОтборСоглашение") И ЗначениеЗаполнено(Отбор.ОтборСоглашение);
	ЕстьФорматМагазина						= Отбор.Свойство("ОтборФорматМагазина") И ЗначениеЗаполнено(Отбор.ОтборФорматМагазина);
	ЕстьНазначение							= Отбор.Свойство("ОтборНазначение");
	
	Если ЕстьСклад Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														Новый ФорматированнаяСтрока(НСтр("ru = 'складу';
																						|en = 'warehouse'") + " ",
														"""",
														Новый ФорматированнаяСтрока(Строка(Отбор.ОтборСклад), Шрифт),
														""""));
	КонецЕсли;
	
	Если ЕстьФорматМагазина Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														Новый ФорматированнаяСтрока(НСтр("ru = 'формату магазина';
																						|en = 'store format'") + " ",
														"""",
														Новый ФорматированнаяСтрока(Строка(Отбор.ОтборФорматМагазина), Шрифт),
														""""));
	КонецЕсли;
	
	Если ЕстьПодразделениеПродажи Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'подразделению продажи';
																						|en = 'sales business unit'") + " ",
														"""",Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПодразделениеПродажи), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьПодразделениеЗакупки Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'подразделению закупки';
																						|en = 'purchase business unit'") + " ",
														"""",Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПодразделениеЗакупки), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьПодразделениеДиспетчер Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'подразделению диспетчеру';
																						|en = 'dispatching unit'") + " ",
														"""",Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПодразделениеДиспетчер), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьПодразделениеВнутреннихПотреблений Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
			?(ЕстьСклад ИЛИ ЕстьФорматМагазина,", ",""),
			Новый ФорматированнаяСтрока(НСтр("ru = 'подразделению внутренних потреблений';
											|en = 'business unit of inventory consumption'") + " ",
			"""",Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПодразделениеВнутреннихПотреблений), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьПартнер Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина ИЛИ ЕстьПодразделение,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'партнеру';
																						|en = 'partner'") + " ",
														"""", Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПартнер), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьСоглашение Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина ИЛИ ЕстьПодразделение ИЛИ ЕстьПартнер,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'соглашению';
																						|en = 'agreement'") + " ",
														"""", Новый ФорматированнаяСтрока(Строка(Отбор.ОтборСоглашение), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьНазначение Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина ИЛИ ЕстьПодразделение ИЛИ ЕстьПартнер ИЛИ ЕстьСоглашение,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru = 'назначению';
																						|en = 'assignment'") + " ",
														"""", Новый ФорматированнаяСтрока(?(ЗначениеЗаполнено(Отбор.ОтборНазначение), Строка(Отбор.ОтборНазначение),НСтр("ru = 'Без назначения';
																																										|en = 'Without appointment'")), Шрифт),""""));
	КонецЕсли;
	
	ЭлементПояснение.Видимость = ЗначениеЗаполнено(ТекстПояснения);
	
	ТекстПояснения = Новый ФорматированнаяСтрока(НСтр("ru = '* Поля с отбором по';
														|en = '* Fields with the filter by'") + " ", ТекстПояснения, ".");
	
	ЭлементПояснение.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРасшифровку(Операнд)
	
	ОперандыСРасшифровкой = ПолучитьОперандыСРасшифровкой();
	
	Если НЕ ОперандыСРасшифровкой.Свойство(Операнд) Тогда
		Возврат;
	КонецЕсли;
	
	МассивИменНаборов = Новый Массив();
	МассивИменНаборов.Добавить(Операнд);
	
	МассивДанныхРасшифровки = ПолучитьРасшифровку(МассивИменНаборов);
	
	Если МассивДанныхРасшифровки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СписокДокументов = Новый СписокЗначений();
	
	Для Каждого ЭлементРасшифровки Из МассивДанныхРасшифровки Цикл
	
		ДокументПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = '%1 (№ %2 от %3)';
										|en = '%1 (No. %2 from %3)'"),
										Формат(ЭлементРасшифровки[Операнд], "ЧДЦ=3"), ЭлементРасшифровки.НомерДокумента, 
										Формат(ЭлементРасшифровки.ДатаДокумента, "ДЛФ=D"));
				
		СписокДокументов.Добавить(ЭлементРасшифровки.Документ, ДокументПредставление);
	
	КонецЦикла;
	Если СписокДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ИмяФормыРасшифровки = ОперандыСРасшифровкой[Операнд] + ".ФормаОбъекта";
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИмяФормыРасшифровки",ИмяФормыРасшифровки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборДокумента", ЭтотОбъект,ДополнительныеПараметры);
	СписокДокументов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru = 'Выберите документ';
																	|en = 'Select document'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокумента(РезультатВыбора, ДополнительныеПараметры) Экспорт 

	Если Не РезультатВыбора = Неопределено Тогда 
		
		Документ = РезультатВыбора.Значение;
		ПоказатьЗначение(, Документ);
		
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Функция ПолучитьОперандыСРасшифровкой()

	ОперандыСРасшифровкой = Новый Структура();
	
	Для Каждого Поле Из ПараметрыРасшифровкиОперативногоПланирования.Поля Цикл
		Значение = Поле.Значение;
		Если Значение.Свойство("Расшифровка") И ЗначениеЗаполнено(Значение.Расшифровка) Тогда
			ОперандыСРасшифровкой.Вставить(Поле.Значение.Имя,Поле.Значение.Расшифровка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОперандыСРасшифровкой;

КонецФункции

&НаСервере
Функция ПолучитьРасшифровку(МассивИменНаборов)

	Возврат Планирование.ПолучитьРасшифровку(МассивИменНаборов, ПараметрыРасшифровкиОперативногоПланирования);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьНачалоПериода(НачалоПериода, Периодичность, Знач Смещение)
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуНачалаПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьОкончаниеПериода(НачалоПериода, Периодичность, Знач Смещение)
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеПериода(Периодичность, НачалоПериода,ОкончаниеПериода) 

	Представление = "";
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	#Иначе 
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
		
	ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(Периодичность, НачалоПериода, ОкончаниеПериода, ТекущаяДатаСеанса);
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Если НачалоМесяца(НачалоПериода) = НачалоМесяца(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, НСтр("ru = 'ДФ=''ММММ гггг''';
														|en = 'DF=''MMMM yyyy'''"));
		Иначе
			Представление = Формат(НачалоПериода, НСтр("ru = 'ДФ=''ММММ гггг''';
														|en = 'DF=''MMMM yyyy'''")) + " - " 
							+ Формат(ОкончаниеПериода, НСтр("ru = 'ДФ=''ММММ гггг''';
															|en = 'DF=''MMMM yyyy'''"));
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Если НачалоДня(НачалоПериода) = НачалоДня(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, "ДЛФ=DD");
		Иначе
			Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		КонецЕсли;
		
	Иначе
		
		Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		
	КонецЕсли;
	
	Возврат Представление;

КонецФункции

&НаСервере
Процедура УстановитьЗаголовокЗначенияОперандов()

	Если Не ПараметрыРасшифровкиОперативногоПланирования.Свойство("НачалоПериодаСмещения")
		ИЛИ ПараметрыРасшифровкиОперативногоПланирования.Свойство("КонецПериодСмещения") Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода 		= ПересчитатьНачалоПериода(ПараметрыРасшифровкиОперативногоПланирования.НачалоПериодаСмещения,
		ПараметрыРасшифровкиОперативногоПланирования.Периодичность,
		ПараметрыРасшифровкиОперативногоПланирования.СмещениеПериода);
	ОкончаниеПериода 	= ПересчитатьОкончаниеПериода(ПараметрыРасшифровкиОперативногоПланирования.КонецПериодаСмещения,
		ПараметрыРасшифровкиОперативногоПланирования.Периодичность,
		ПараметрыРасшифровкиОперативногоПланирования.СмещениеПериода);
	
	ПериодВыборки 		= СформироватьПредставлениеПериода(ПараметрыРасшифровкиОперативногоПланирования.Периодичность,
		НачалоПериода, ОкончаниеПериода);
	
	ТекстЗаголовка = НСтр("ru = 'Значение (%1)';
							|en = 'Value (%1)'");
	ТекстЗаголовка = СтрШаблон(ТекстЗаголовка, ПериодВыборки);
	Элементы.ГруппаОперанды.Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДеревоОперандов()

	Дерево = ПолучитьИзВременногоХранилища(АдресДереваОперандов);
	
	Если ТипЗнч(Дерево) <> Тип("ДеревоЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ОперандыСоЗначениями = Новый Соответствие();
	МассивРазрешенныхОперандов = Новый Массив;
	РаботаСФормулами.ЗагрузитьДеревоОперандовВДеревоФормы(ДеревоОперандов,
		Дерево,
		МассивРазрешенныхОперандов,
		ОперандыСоЗначениями);
	РазрешенныеОперанды = Новый ФиксированныйМассив(МассивРазрешенныхОперандов);
	ЗначенияОперандов = Новый ФиксированноеСоответствие(ОперандыСоЗначениями);
	
	ТипыРазрешенныхОперандов = Новый Соответствие();
	Для каждого Операнд Из МассивРазрешенныхОперандов Цикл
		Строка = Дерево.Строки.Найти(Операнд, "Идентификатор", Истина);
		Если Строка <> Неопределено Тогда
			ТипыРазрешенныхОперандов.Вставить(Операнд, Строка.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	ТипыОперандов = Новый ФиксированноеСоответствие(ТипыРазрешенныхОперандов);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПроверкиФормулы()
	
	ПараметрыПроверки = РаботаСФормуламиКлиент.ПараметрыПроверкиФормулы();
	//++ НЕ УТ
	ПараметрыПроверки.ФормулаДляВычисленияВЗапросе = ФормулаДляВычисленияВЗапросе;
	//-- НЕ УТ
	Если ЗначениеЗаполнено(ФункцииИзОбщегоМодуля) Тогда
		ПараметрыПроверки.ФункцииОбщегоМодуля = ФункцииИзОбщегоМодуля;
	КонецЕсли;
	ПараметрыПроверки.Поле = "Формула";
	ПараметрыПроверки.ТипыОперандов = ТипыОперандов;
	
	Возврат ПараметрыПроверки;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеОператоровИОперандов()
	УстановитьУсловноеОформлениеОператоров();
	УстановитьУсловноеОформлениеОперандов();
КонецПроцедуры

// Параметры:
// 	ТипСобытийОповещений - ПеречислениеСсылка.ТипыСобытийОповещений, Неопределено - 
&НаСервере
Процедура УстановитьУсловноеОформлениеОператоров()
	
	// Если строка дерева операторов - группа, то идентификатор не показывается.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Операторы.ЭтоГруппа");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	ПараметрВидимость = Новый ПараметрКомпоновкиДанных("Видимость");
	Для Каждого ПараметрОформления Из ЭлементОформления.Оформление.Элементы Цикл
		Если ПараметрОформления.Параметр = ПараметрВидимость Тогда
			ПараметрОформления.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле =  Новый ПолеКомпоновкиДанных(Элементы.ОператорыИдентификатор.Имя);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеОперандов()
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти
