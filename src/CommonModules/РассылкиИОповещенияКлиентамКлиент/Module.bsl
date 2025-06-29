////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылки и оповещения клиентам".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  Содержит общие клиентские процедуры и функции при работе с функционалом
//  рассылок и оповещений клиентов.
//

#Область СлужебныйПрограммныйИнтерфейс

// Интерактивное добавление вложения электронного письма.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма, в которой выполняется добавление вложения.
//
Процедура ДобавитьВложениеВыполнить(Форма) Экспорт
	
	#Если Не ВебКлиент Тогда
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.МножественныйВыбор = Истина;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		
		ВыборФайловОкончание = Новый ОписаниеОповещения("ВыборФайловОкончание", ЭтотОбъект, ДополнительныеПараметры);
		
		Диалог.Показать(ВыборФайловОкончание);
		
	#Иначе

		ОписаниеОповещенияОкончаниеПомещения = Новый ОписаниеОповещения("ДобавитьВложениеВыполнитьЗавершение",
		                                                                ЭтотОбъект, Новый Структура("Форма", Форма));
		НачатьПомещениеФайла(ОписаниеОповещенияОкончаниеПомещения, "", "", Истина, Форма.УникальныйИдентификатор);
		Возврат;
		
	#КонецЕсли
	
КонецПроцедуры

Процедура ВыборФайловОкончание(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Вложения = Форма.Вложения; // ТаблицаЗначений
	
	Для Каждого ВыбранныйФайл Из ВыбранныеФайлы Цикл
		
		Форма.Модифицированность = Истина;
		
		НоваяСтрока = Вложения.Добавить(); // см. СтрокаТаблицыВложений
		НоваяСтрока.Расположение = 2;
		НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
		
		ИмяФайла = ИмяФайлаБезКаталога(ВыбранныйФайл);
		НоваяСтрока.ИмяФайла = ИмяФайла;
		
		Расширение                      = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
		НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ИндексПиктограммыФайла(Расширение);
		Файл                            = Новый Файл(ВыбранныйФайл);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СтрокаТЧ", НоваяСтрока);
		ОповещениеПослеПолученияРазмера = Новый ОписаниеОповещения("ПолучениеРазмераФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьПолучениеРазмера(ОповещениеПослеПолученияРазмера);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучениеРазмераФайлаЗавершение(Размер, ДополнительныеПараметры) Экспорт
	
	Если Размер = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = ДополнительныеПараметры.СтрокаТЧ; // см. СтрокаТаблицыВложений
	
	СтрокаТЧ.Размер              = Размер;
	СтрокаТЧ.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(СтрокаТЧ.Размер);
	
КонецПроцедуры

Процедура ДобавитьВложениеВыполнитьЗавершение(Результат, Адрес, ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Вложения = Форма.Вложения; // ТаблицаЗначений
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Вложения.Добавить(); // см. СтрокаТаблицыВложений
	НоваяСтрока.Расположение = 4;
	НоваяСтрока.ИмяФайлаНаКомпьютере = Адрес;
	НоваяСтрока.ИмяФайла = ВыбранныйФайл;
	
	Расширение = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ВыбранныйФайл);
	НоваяСтрока.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ИндексПиктограммыФайла(Расширение);
	
	Форма.Модифицированность = Истина;
	Форма.ОбновитьОтображениеДанных();
	
КонецПроцедуры

// Открытие файла, размещенного в таблице Вложений.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма, в которой выполняется действие.
//
Процедура ОткрытьВложениеВыполнить(Форма) Экспорт
	
	ТекДанные = Форма.Элементы.Вложения.ТекущиеДанные; // см. СтрокаТаблицыВложений
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ТекДанные.Расположение = 0) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиКлиент.ДанныеФайла(ТекДанные.Ссылка, Форма.УникальныйИдентификатор), Ложь);
		
	ИначеЕсли текДанные.Расположение = 2 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			Оповещение = Новый ОписаниеОповещения("ЗапускПриложенияЗавершить", ЭтотОбъект);
			ОбщегоНазначенияКлиент.ОткрытьФайлВПрограммеПросмотра("" + ПутьКФайлу + "", Оповещение);
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	ИначеЕсли текДанные.Расположение = 4 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Ложь);
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапускПриложенияЗавершить(Подключено, ДополнительныеПараметры) Экспорт

	Если Подключено = Неопределено Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

// Помещает файлы, расположенные в таблице Вложения во временное хранилище.
//
// Параметры:
//  Вложения  - ТаблицаЗначений - таблица, содержащая вложения:
//    * Расположение         - Число -
//    * ИмяФайлаНаКомпьютере - Строка
//
Процедура ПоместитьВложенияВоВременноеХранилище(Вложения) Экспорт
	
	#Если Не ВебКлиент Тогда
	Для Каждого СтрокаТаблицыВложений Из Вложения Цикл
		Если СтрокаТаблицыВложений.Расположение = 2 Тогда 
			Данные = Новый ДвоичныеДанные(СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере);
			СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере = ПоместитьВоВременноеХранилище(Данные, "");
			СтрокаТаблицыВложений.Расположение = 4;
		КонецЕсли;
	КонецЦикла;
	#КонецЕсли
	
КонецПроцедуры

// Обрабатывает перетаскивание одного или нескольких файлов в таблицу вложений.
//
// Параметры:
//  Вложения  - ТаблицаЗначений - таблица, содержащая вложения:
//     * Расположение         - Число -
//     * ИмяФайлаНаКомпьютере - Строка -
//     * ИндексКартинки       - Число
//  ПараметрыПеретаскивания  - ПараметрыПеретаскивания - параметры операции перетаскивания.
//
Процедура ОбработатьПеретаскиваниеВложения(Вложения, ПараметрыПеретаскивания) Экспорт
	
#Если Не ВебКлиент Тогда
    
    // Инструкция препроцессора нужна для того, чтобы платформенная проверка конфигурации
    // не находила синхронные методы работы с файлами. В веб клиенте данная процедура все равно
    // не вызывается из-за особенностей перетаскивания файлов в браузере.
    
	МассивИменФайлов = Новый Массив;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл")
		И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				Если ТипЗнч(ФайлПринятый) = Тип("Файл") И ФайлПринятый.ЭтоФайл() Тогда
					МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ВыбранныйФайл Из МассивИменФайлов Цикл
			
			НоваяСтрока = Вложения.Добавить();
			НоваяСтрока.Расположение = 2;
			НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
			
			ИмяФайла = ИмяФайлаБезКаталога(ВыбранныйФайл);
			НоваяСтрока.ИмяФайла = ИмяФайла;
			
			Расширение                      = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
			НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ИндексПиктограммыФайла(Расширение);
			Файл                            = Новый Файл(ВыбранныйФайл);
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("СтрокаТЧ", НоваяСтрока);
			ОповещениеПослеПолученияРазмера = Новый ОписаниеОповещения("ПолучениеРазмераФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			Файл.НачатьПолучениеРазмера(ОповещениеПослеПолученияРазмера);
	
	КонецЦикла;
	
#КонецЕсли

КонецПроцедуры

// Удаляет файл из таблицы Вложения и перемещает в массив вложений к удалению.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма, в которой выполняется действие.
//
Процедура ПереместитьВложениеВУдаленные(Форма) Экспорт

	Вложения = Форма.Элементы.Вложения; // ТаблицаЗначений
	УдаленныеВложения = Форма.УдаленныеВложения; // СписокЗначений - 
	ТекущиеДанные = Вложения.ТекущиеДанные; // см. СтрокаТаблицыВложений 
	Если (ТекущиеДанные <> Неопределено)  Тогда
		Если ТекущиеДанные.Расположение = 0 Тогда
			УдаленныеВложения.Добавить(ТекущиеДанные.Ссылка);
		КонецЕсли;
		Индекс = Вложения.Индекс(ТекущиеДанные);
		Форма.Вложения.Удалить(Индекс);
		Форма.ОбновитьОтображениеДанных();
		Форма.Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

// Функция конструктор, описывающая стуруктуру, соответствующую строка таблицы Вложений. 
// 
// Возвращаемое значение:
//  Структура - содержит:
//    * Расположение - Число -
//    * Ссылка       - СправочникСсылка.ЭлектронноеПисьмоИсходящееПрисоединенныеФайлы -
//    * ИмяФайла             - Строка - 
//    * ИмяФайлаНаКомпьютере - Строка - 
//    * Размер               - Число - 
// 	
Функция СтрокаТаблицыВложений() Экспорт
	
	ДанныеСтрокиТаблицыВложений = Новый Структура;
	ДанныеСтрокиТаблицыВложений.Вставить("Расположение");
	ДанныеСтрокиТаблицыВложений.Вставить("Ссылка");
	ДанныеСтрокиТаблицыВложений.Вставить("ИмяФайла");
	ДанныеСтрокиТаблицыВложений.Вставить("ИмяФайлаНаКомпьютере");
	ДанныеСтрокиТаблицыВложений.Вставить("Размер");
	
	Возврат ДанныеСтрокиТаблицыВложений;
	
КонецФункции

// Открывает форму подписки для подписчика и группы рассылок и оповещений.
//
// Параметры:
//  Подписчик                  - СправочникСсылка.Партнеры - подписчик, для которого необходимо открыть подписку.
//  ГруппаРассылокИОповещений  - СправочникСсылка.ГруппыРассылокИОповещений - группа, для которой необходимо открыть подписку.
//  Форма                      - ФормаКлиентскогоПриложения - форма, в которой выполняется действие.
//
Процедура ОткрытьФормуПодписки(Подписчик, ГруппаРассылокИОповещений, Форма) Экспорт
	
	Подписка = РассылкиИОповещенияКлиентамВызовСервера.ПодпискаДляПодписчика(Подписчик, ГруппаРассылокИОповещений);
	РедактироватьПодписку(Подписка, Подписчик, ГруппаРассылокИОповещений, Форма);
	
КонецПроцедуры

// Открывает форму подписки.
//
// Параметры:
//  Подписка                   - СправочникСсылка.ПодпискиНаРассылкиИОповещенияКлиентам - открываемая подписка.
//  Подписчик                  - СправочникСсылка.Партнеры - подписчик.
//  ГруппаРассылокИОповещений  - СправочникСсылка.ГруппыРассылокИОповещений - группа.
//  Форма                      - ФормаКлиентскогоПриложения - форма, в которой выполняется действие.
//  Действует                  - Булево - признак того, что подписка действует.
//
Процедура РедактироватьПодписку(Подписка, Подписчик, ГруппаРассылокИОповещений, Форма, Действует = Истина) Экспорт

	Если Подписка.Пустая() Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПравоИзменения")
			И Не Форма.ПравоИзменения Тогда
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец", Подписчик);
		ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", ГруппаРассылокИОповещений);
		ЗначенияЗаполнения.Вставить("ПодпискаДействует", Действует);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	Иначе
		
		ПараметрыФормы = Новый Структура("Ключ", Подписка);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ФормаОбъекта",
	             ПараметрыФормы,
	             Форма);

КонецПроцедуры

// Формирует параметры формы подбора партнеров по отбору.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма, из которой вызывается подбор.
//
// Возвращаемое значение:
//   Структура   - сформированные параметры формы подбора.
//
Функция ПараметрыФормыПодбораПоОтбору(Форма) Экспорт

	ЗаголовокФормыПодбора = НСтр("ru = 'Подбор подписчиков для группы рассылок и оповещений';
								|en = 'Pick subscribers for the group of mailouts and notifications'");
	ЗаголовокКнопкиПеренестиФормыПодбора = НСтр("ru = 'Перенести в подписку';
												|en = 'Move to subscription'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",                               ЗаголовокФормыПодбора);
	ПараметрыФормы.Вставить("ЗаголовокКнопкиПеренести",                ЗаголовокКнопкиПеренестиФормыПодбора);
	ПараметрыФормы.Вставить("УникальныйИдентификатор",                 Форма.УникальныйИдентификатор);
	ПараметрыФормы.Вставить("ПредназначенаДляSMS",                     Форма.ПредназначенаДляSMS);
	ПараметрыФормы.Вставить("ПредназначенаДляЭлектронныхПисем",        Форма.ПредназначенаДляЭлектронныхПисем);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформацииПартнераДляПисем", Форма.ВидКонтактнойИнформацииПартнераДляПисем);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформацииПартнераДляSMS",   Форма.ВидКонтактнойИнформацииПартнераДляSMS);
	
	Возврат ПараметрыФормы;

КонецФункции

// Обработчик команды настройки подписки на оповещения из объекта.
//
// Параметры:
//  Партнер     - СправочникСсылка.Партнеры - партнер, для которого будет настраиваться подписка.
//  ТипСобытия  - Массив, ПеречислениеСсылка.ТипыСобытийОповещений - типы событий, для которых оформляется подписка.
//
Процедура НастроитьПодпискуНаОповещенияИзОбъекта(Партнер, ТипСобытия) Экспорт

	МассивДоступныхГруппОповещений = РассылкиИОповещенияКлиентамВызовСервера.ДоступныеГруппыОповещенийПоТипуСобытия(ТипСобытия);
	СписокДоступныхГруппОповещений = Новый СписокЗначений();
	СписокДоступныхГруппОповещений.ЗагрузитьЗначения(МассивДоступныхГруппОповещений);
	КоличествоДоступныхГруппОповещений = МассивДоступныхГруппОповещений.Количество();
	
	Если КоличествоДоступныхГруппОповещений = 1 Тогда
		
		ЗначенияЗаполнения = Новый Структура();
		ЗначенияЗаполнения.Вставить("Владелец", Партнер);
		ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", МассивДоступныхГруппОповещений[0]);
		ЗначенияЗаполнения.Вставить("ПодпискаДействует", Истина);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли КоличествоДоступныхГруппОповещений > 1 Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Подписчик", Партнер);
		ПараметрыФормы.Вставить("ГруппыРассылокИОповещений", СписокДоступныхГруппОповещений);
		
		ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.Форма.ФормаСпискаОтПодписчика", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяФайлаБезКаталога(Знач ПолноеИмяФайла)
	
	ИмяФайла = ПолноеИмяФайла;
	Пока Истина Цикл
		
		Позиция = Макс(СтрНайти(ИмяФайла, "\"), СтрНайти(ИмяФайла, "/"));
		Если Позиция = 0 Тогда
			Возврат ИмяФайла;
		КонецЕсли;
		
		ИмяФайла = Сред(ИмяФайла, Позиция + 1);
		
	КонецЦикла;
	Возврат ИмяФайла;
	
КонецФункции

#КонецОбласти
